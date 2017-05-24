RSpec.describe Foo, type: :model do
  describe "hello world" do
    it "returns hello world" do
      foo = create(:foo)
      expect(foo.hello_world).to eq "hello world"
    end
  end
end
