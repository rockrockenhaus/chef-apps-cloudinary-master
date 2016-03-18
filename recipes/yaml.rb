#
# Cookbook Name:: apps-cloudinary
# Recipe:: yaml
#
# Copyright 2015, getaroom
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

encrypted_apps = data_bag("apps_encrypted")

search :apps do |base_app|
  encrypted_app = encrypted_apps.include?(base_app['id']) ? Chef::EncryptedDataBagItem.load("apps_encrypted", base_app['id']) : {}
  app = Chef::Mixin::DeepMerge.merge(base_app.to_hash, encrypted_app.to_hash)

  if (app['server_roles'] & node.run_list.roles).any?
    if app.fetch("ingredients", {}).any? { |role, ingredients| node.run_list.roles.include?(role) && ingredients.include?("cloudinary.yml") }
      cloudinary_config            = app.fetch("cloudinary", {})
      framework_environment_config = cloudinary_config.fetch(node['framework_environment'], {})

      config = Apps::Cloudinary::DeepToHash.to_hash(node['framework_environment'] => framework_environment_config)

      file "#{app['deploy_to']}/shared/config/cloudinary.yml" do
        owner app['owner']
        group app['group']
        mode "660"
        content config.to_yaml
      end
    end
  end
end
