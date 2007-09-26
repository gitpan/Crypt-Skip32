use strict;
#
# Cript-Skip32.t - Unit test for Crypt::Skip32
#

use Test::More tests => 42;
use Test::Exception;

BEGIN { use_ok('Crypt::Skip32') };

# Create cipher
my $cipher1 = new Crypt::Skip32 pack("H20", "DE2624BD4FFC4BF09DAB");
ok($cipher1,
   "create cipher 1");

# Standard size methods
is($cipher1->blocksize, 4,
   "blocksize is 4");
is($cipher1->keysize, 10,
   "keysize is 10");

# Try out a few encrypt/decrypt
test($cipher1,          0,   78612854);
test($cipher1,          3, 3719912389);
test($cipher1,         21, 1463300585);
test($cipher1,        147, 1277082297);
test($cipher1,       1029, 2878029910);
test($cipher1,       7203, 4086218104);
test($cipher1,      50421, 2588160464);
test($cipher1,     352947, 2703568194);
test($cipher1,    2470629, 2600508864);
test($cipher1,   17294403, 4119915301);
test($cipher1,  121060821, 4266122367);
test($cipher1,  847425747, 2671425558);
test($cipher1, 4294967295,  949651845);

# Different cipher keys
my $cipher_text_1 = test($cipher1, 123456789, 2982653749);

my $cipher2 = new Crypt::Skip32 pack("H20", "EC1D4396C19C0E0A1CC8");
ok($cipher2,
   "create cipher 2");

my $cipher_text_2 = test($cipher2, 123456789, 2798020216);

isnt($cipher_text_1, $cipher_text_2,
     'different keys produce different encrypted text');

# Error conditions
dies_ok { my $cipher3 = new Crypt::Skip32 'shortkey'; }
        "new() dies correctly on key too short";

dies_ok { my $cipher3 = new Crypt::Skip32 'keythatistoolong'; }
        "new() dies correctly on key too long";

dies_ok { $cipher1->encrypt('abc'); }
        "encrypt() dies correctly on plaintext too short";

dies_ok { $cipher1->encrypt('abcde'); }
        "encrypt() dies correctly on plaintext too long";

dies_ok { $cipher1->decrypt('abc'); }
        "encrypt() dies correctly on ciphertext too short";

dies_ok { $cipher1->decrypt('abcde'); }
        "decrypt() dies correctly on ciphertext too long";

exit 0;

sub test {
  my ($cipher, $plain_number, $correct_cipher_number) = @_;

  my $plain_text_1    = pack('N', $plain_number);

  my $cipher_text     = $cipher->encrypt($plain_text_1);
  my $plain_text_2    = $cipher->decrypt($cipher_text);

  my $cipher_number   = unpack('N', $cipher_text);

  is($cipher_number, $correct_cipher_number,
    "Skip32 encrypt $plain_number -> $cipher_number");

  is($plain_text_1, $plain_text_2,
    "Skip32 decrypt $cipher_number -> $plain_number");

  return $cipher_text;
}