RSpec.describe Foo, type: :model do
  describe "hello world" do
    it "returns hello world" do
      foo = create(:foo)
      expect(foo.hello_world).to eq "hello world"
    end

    it "responds to title and name methods" do
      foo = create(:foo, name: "bob", title: "Chef")
      expect(foo.name).to eq "bob"
      expect(foo.title).to eq "Chef"
    end
  end
end
