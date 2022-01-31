#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# ==============================================================================
# File:         urlencoder.py
# Author:       Cashiuus
# Created:      21-Jan-2022     -     Revised:
#
#   A quick and simple url encoder for a string input
# ==============================================================================
__version__ = '0.0.1'
__author__ = 'Cashiuus'
__license__ = 'MIT'
__copyright__ = 'Copyright (C) 2022 Cashiuus'


import argparse



def urlencode_php(s):
    """
    Process string and convert certain characters to URL encoding equivalent.
    This urlencode method is specific to payloads sent with the
    Content-Type: application/x-www-form-urlencoded
    URL: https://www.w3schools.in/php/url-encoding-and-decoding-with-php/

    """
    patterns = {
        " ": "+",
        "&": "%26",
        ";": "%3b",
    }
    #encoded_s = s.replace(" ", "+")
    for k, v in patterns.items():
        s = s.replace(k, v)
        print("{}".format(s))
    return s


# ---------------------
#   main
# ---------------------
def main():
    """
    Main function of the script
    """
    parser = argparse.ArgumentParser()
    parser = argparse.ArgumentParser(description="Attack string url encoder specifically for form-urlencoded content type requests")
    parser.add_argument('input', help="String you wish to URL Encode (for PHP)")
    args = parser.parse_args()

    input_string = "{}".format(args.input)
    print("{}".format(urlencode_php(input_string)))

    return



if __name__ == '__main__':
    main()



### Notes on URL Encoding
#
#
#
# - RFC2396 defines the classes of characters -
#
# Unreserved:   a-z, A-Z, 0-9 and _ . ! ~ * ' ( )
# Reserved:     ; / ? : @ & = + $ ,
#
# Unreserved characters have no "reserved" purpose.
# Reserved characters could conflict with interpretation of a URI. They are still allowed
#   within a URI, but may not be allowed within a particular segment of the generic URI syntax.
#
# - Escaped Encoding - (percent encoding)
#
# This is the accepted method of representing characters within a URI that may need special
#   handling to be correctly interpreted. The percent encoding is % and 2 hex digits
#   (the octet code of the original character).
#
# Unreserved characters *can* be escaped but should not be done unless the URI is being used
#   in a context that does not allow the un-escaped character to appear.
#
# - RFC2396 defines grouping characters -
# These must be escaped to be included in a URI
#
#   Control     <ASCII chars 00-1F and 7F hexadecimal>
#   Space       <ASCII coded char 20 hex>
#   Delims      < > # % "
#   Unwise      { } | \ [ ] `
#
#
#
### Specific to PHP
#
#
#
# - Content-Type: application/x-www-form-urlencoded
#       - https://www.w3schools.in/php/url-encoding-and-decoding-with-php/
#
# This is a type of encoding-decoding approach where the built-in PHP functions urlencode()
# and urldecode()are implemented to encode and decode the URL, respectively. This encoding
# will replace almost all the special characters other than (_), (-), and (.) in the given
# URL. Space is also replaced with a (+) plus sign rather than a %[hex code].
#
#
#
#

