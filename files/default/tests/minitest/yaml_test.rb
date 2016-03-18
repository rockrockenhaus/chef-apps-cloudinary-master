describe_recipe "apps-cloudinary::yaml" do
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  describe "cloudinary.yml for an app hosted on this server" do
    let(:app_user) { user "www" }
    let(:app_group) { group "www" }
    let(:yml) { file "/srv/www/shared/config/cloudinary.yml" }
    let(:stat) { File.stat(yml.path) }

    it "exists" do
      yml.must_exist
    end

    it "is owned by the app user" do
      assert_equal app_user.uid, stat.uid
      assert_equal app_group.gid, stat.gid
    end

    it "is mode 660" do
      assert_equal "660".oct, (stat.mode & 007777)
    end

    it "does not serialize any special types" do
      yml.wont_include "!"
    end

    it "contains information about the cloudinary environments" do
      expected_yaml = {
        "staging" => {
          "cloud_name" => "cloud_name",
          "api_key" => "api_key",
          "api_secret" => "secret",
        },
      }

      actual_yaml = YAML.load_file(yml.path)
      assert_equal expected_yaml.keys.sort, actual_yaml.keys.sort

      expected_yaml.keys.each do |key|
        assert_equal expected_yaml[key], actual_yaml[key]
      end
    end
  end

  describe "an application not hosted on this server" do
    it "does not create a cloudinary.yml file" do
      file("/srv/princess/shared/config/cloudinary.yml").wont_exist
    end
  end

  describe "an application hosted on this server but not using cloudinary" do
    it "does not create a cloudinary.yml file" do
      file("/srv/toad/shared/config/cloudinary.yml").wont_exist
    end
  end
end