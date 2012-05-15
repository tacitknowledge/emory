require 'spec_helper'
require 'emory/configuration_file'

module Emory
  
  describe ConfigurationFile do

    context "'locate' method" do

      it "finds config file on its path" do
        Dir.should_receive(:pwd).and_return('/qwe/asd/zxc/')
        File.should_receive(:exists?).with('/qwe/asd/zxc/.emory').and_return(false)
        File.should_receive(:exists?).with('/qwe/asd/.emory').and_return(false)
        File.should_receive(:exists?).with('/qwe/.emory').and_return(true)

        ConfigurationFile.locate.should == '/qwe/.emory'
      end

      it "finds config file in current directory" do
        Dir.should_receive(:pwd).and_return('/qwe/asd/zxc/')
        File.should_receive(:exists?).with('/qwe/asd/zxc/.emory').and_return(true)

        ConfigurationFile.locate.should == '/qwe/asd/zxc/.emory'
      end

      it "raises exception if config file was not found on its path up to root" do
        Dir.should_receive(:pwd).and_return('/qwe/asd/zxc/')
        File.should_receive(:exists?).with('/qwe/asd/zxc/.emory').and_return(false)
        File.should_receive(:exists?).with('/qwe/asd/.emory').and_return(false)
        File.should_receive(:exists?).with('/qwe/.emory').and_return(false)
        File.should_receive(:exists?).with('/.emory').and_return(false)

        proc {
          ConfigurationFile.locate
        }.should raise_error(EmoryConfigurationFileNotFoundException,
                             /Configuration file \(\.emory\) was not found/)
      end

    end

  end

end
