require 'spec_helper'

module Emory
  
  describe ConfigurationFile do
    context "#read" do
      before(:each) do
        @configuration_file_name = '.emory'
        @current_path = '/root/sources/emory'
        @start_search_sentence = "Start to search for configuration file: %s"
        @search_info = "Searching for configuration file under: %s"
        @file_found = "configuration file found: %s"
        @file_not_found = "configuration file NOT found"
        Dir.should_receive(:pwd).and_return(@current_path)
      end
      
      it 'should raise error if no configuration file found' do
        File.should_receive(:exists?).exactly(4).times.and_return(false)
        ConfigurationFile.should_receive(:puts).with(@start_search_sentence % @configuration_file_name)
        
        @current_path.split('/').each do |word|
          @path = '/' if word.empty?
          ConfigurationFile.should_receive(:puts).with(@search_info % @path += word)
          @path += '/' unless word.empty?
        end
        
        expect {
          ConfigurationFile.locate
        }.to raise_error(@file_not_found)
      end
      
      it 'should find configuration file in current directory' do
        file_full_path = @current_path + '/' + @configuration_file_name
        File.should_receive(:exists?).once.and_return(true)
        
        ConfigurationFile.should_receive(:puts).with(@start_search_sentence % @configuration_file_name)
        ConfigurationFile.should_receive(:puts).with(@search_info % @current_path)
        ConfigurationFile.should_receive(:puts).with(@file_found % file_full_path)
        
        ConfigurationFile.locate.should == file_full_path
      end
      
      it 'should find configuration file in parent directory of current directory' do
        parent_directory = '/root/sources'
        file_full_path = parent_directory + '/' + @configuration_file_name
        File.should_receive(:exists?).twice.and_return(false, true)
        
        ConfigurationFile.should_receive(:puts).with(@start_search_sentence % @configuration_file_name)
        ConfigurationFile.should_receive(:puts).with(@search_info % @current_path)
        ConfigurationFile.should_receive(:puts).with(@search_info % parent_directory)
        ConfigurationFile.should_receive(:puts).with(@file_found % file_full_path)
        
        ConfigurationFile.locate.should == file_full_path
      end
      
      it 'should find configuration file in root directory' do
        file_full_path = '/' + @configuration_file_name
        File.should_receive(:exists?).exactly(4).times.and_return(false, false, false, true)
        
        ConfigurationFile.should_receive(:puts).with(@start_search_sentence % @configuration_file_name)
        @current_path.split('/').each do |word|
          @path = '/' if word.empty?
          ConfigurationFile.should_receive(:puts).with(@search_info % @path += word)
          @path += '/' unless word.empty?
        end
        ConfigurationFile.should_receive(:puts).with(@file_found % file_full_path)
        
        ConfigurationFile.locate.should == file_full_path
      end

    end
  end

end