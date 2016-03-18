name "www"
description "Tests for Cloudinary"

run_list(
  "recipe[users::sysadmins]",
  "recipe[apps]",
  "recipe[apps-cloudinary::yaml]",
)

default_attributes({
  "minitest" => {
    "tests" => "apps-cloudinary/*_test.rb",
  }
})
