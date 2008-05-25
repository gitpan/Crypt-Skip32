use 5.008000;
use ExtUtils::MakeMaker;
WriteMakefile(
    NAME              => 'Crypt::Skip32',
    VERSION_FROM      => 'lib/Crypt/Skip32.pm', # finds $VERSION
    PREREQ_PM         => {
			  Test::More      => 0.62,
			 },
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Crypt/Skip32.pm', # retrieve abstract from module
       AUTHOR         => 'Eric Hammond <eric-cpan@thinksome.com>') : ()),
    (MM->can('signature_target') ? (SIGN => 1) : ()),
);
