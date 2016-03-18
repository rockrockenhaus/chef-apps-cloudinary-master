name             "apps-cloudinary"
maintainer       "getaroom"
maintainer_email "devteam@roomvaluesteam.com"
license          "MIT"
description      "Configures Cloudinary for Apps"
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))
version          "1.0.0"

depends "apps"

supports "debian"
supports "ubuntu"

recipe "apps-cloudinary", "Configures Cloudinary for apps."
recipe "apps-cloudinary::yaml", "Generates a cloudinary.yml file."
