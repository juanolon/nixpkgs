{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "gnutar-${version}";
  version = "1.28";

  src = fetchurl {
    url = "mirror://gnu/tar/tar-${version}.tar.bz2";
    sha256 = "0qkm2k9w8z91hwj8rffpjj9v1vhpiriwz4cdj36k9vrgc3hbzr30";
  };

  patches = stdenv.lib.optional stdenv.isDarwin ./gnutar-1.28-darwin.patch;

  # gnutar tries to call into gettext between `fork` and `exec`,
  # which is not safe on darwin.
  # see http://article.gmane.org/gmane.os.macosx.fink.devel/21882
  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/system.c --replace '_(' 'N_('
  '';

  buildInputs = stdenv.lib.optional stdenv.isDarwin autoreconfHook;

  # May have some issues with root compilation because the bootstrap tool
  # cannot be used as a login shell for now.
  FORCE_UNSAFE_CONFIGURE = stdenv.lib.optionalString (stdenv.system == "armv7l-linux" || stdenv.isSunOS) "1";

  meta = {
    homepage = http://www.gnu.org/software/tar/;
    description = "GNU implementation of the `tar' archiver";

    longDescription = ''
      The Tar program provides the ability to create tar archives, as
      well as various other kinds of manipulation.  For example, you
      can use Tar on previously created archives to extract files, to
      store additional files, or to update or list files which were
      already stored.

      Initially, tar archives were used to store files conveniently on
      magnetic tape.  The name "Tar" comes from this use; it stands
      for tape archiver.  Despite the utility's name, Tar can direct
      its output to available devices, files, or other programs (using
      pipes), it can even access remote devices or files (as
      archives).
    '';

    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
