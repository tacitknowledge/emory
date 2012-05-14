require 'spec_helper'

module Emory
  
  describe ConfigurationFile do
    context "#read" do
      before(:each) do
        
        @start_search_info = ConfigurationFile::START_SEARCH_INFO
        @search_info = ConfigurationFile::SEARCH_INFO
        @file_found_info = ConfigurationFile::FILE_FOUND_INFO
        @file_not_found_error = ConfigurationFile::FILE_NOT_FOUND_ERROR
        @configuration_file_name = ConfigurationFile::CONFIG_FILE_NAME
        @parent_dir = ConfigurationFile::PARENT_DIRECTORY
        @slash = '/'
        @current_path = '/root/sources/emory'
        Dir.should_receive(:pwd).and_return(@current_path)
        @logger = double('logger')
        Emory::Logger.should_receive(:log_for).and_return(@logger)
      end
      
      it 'should raise error if no configuration file found' do
        File.should_receive(:exists?).exactly(4).times.and_return(false)
        @logger.should_receive(:info).with(@start_search_info % @configuration_file_name)
        
        @current_path.split(@slash).each do |word|
          @path = @slash if word.empty?
          @logger.should_receive(:info).with(@search_info % @path += word)
          @path += @slash unless word.empty?
        end
        
        expect {
          ConfigurationFile.locate
        }.to raise_error(@file_not_found_error)
      end
      
      it 'should find configuration file in current directory' do
        file_full_path = @current_path + @slash + @configuration_file_name
        File.should_receive(:exists?).and_return(true)
        
        @logger.should_receive(:info).with(@start_search_info % @configuration_file_name)
        @logger.should_receive(:info).with(@search_info % @current_path)
        @logger.should_receive(:info).with(@file_found_info % file_full_path)
        
        ConfigurationFile.locate.should == file_full_path
      end
      
      it 'should find configuration file in parent directory of current directory' do
        parent_directory = File.expand_path(@parent_dir, @current_path)
        file_full_path = File.expand_path(@configuration_file_name, parent_directory)
        File.should_receive(:exists?).twice.and_return(false, true)
        
        @logger.should_receive(:info).with(@start_search_info % @configuration_file_name)
        @logger.should_receive(:info).with(@search_info % @current_path)
        @logger.should_receive(:info).with(@search_info % parent_directory)
        @logger.should_receive(:info).with(@file_found_info % file_full_path)
        
        ConfigurationFile.locate.should == file_full_path
      end
      
      it 'should find configuration file in root directory' do
        file_full_path = @slash + @configuration_file_name
        File.should_receive(:exists?).exactly(4).times.and_return(false, false, false, true)
        
        @logger.should_receive(:info).with(@start_search_info % @configuration_file_name)
        @current_path.split(@slash).each do |word|
          @path = @slash if word.empty?
          @logger.should_receive(:info).with(@search_info % @path += word)
          @path += @slash unless word.empty?
        end
        @logger.should_receive(:info).with(@file_found_info % file_full_path)
        
        ConfigurationFile.locate.should == file_full_path
      end

    end
  end

end