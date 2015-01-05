require 'spec_helper'

describe ReplaceGemname::ReplaceCls do
  subject(:replace_cls) { ReplaceGemname::ReplaceCls.new }

  describe ".new" do
    it "makes a new instance" do
      expect(replace_cls).to be_a ReplaceGemname::ReplaceCls
    end
  end
end
