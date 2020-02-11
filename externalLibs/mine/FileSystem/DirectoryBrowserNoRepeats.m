classdef DirectoryBrowserNoRepeats < DirectoryBrowserAbstract
    methods
        function obj = DirectoryBrowserNoRepeats(dirPath)
            %get the files in the current directory
            files=dir(dirPath);
            %keep just the directories
            dirFlags=[files.isdir];
            subFolders = files(dirFlags);
            %remove folder containing _repeats
            subFolders = subFolders(~contains(string({subFolders.name}),'_repeat'));
            %remove the first and second subfolders, these represent the .
            %and ..
            obj.subFolders = {subFolders(3:end).name};
            obj.subFoldersFullPath = fullfile(dirPath,obj.subFolders);
            obj.numFolders=length(obj.subFolders);
        end
    end
end

