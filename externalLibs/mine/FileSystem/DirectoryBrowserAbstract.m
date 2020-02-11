classdef (Abstract) DirectoryBrowserAbstract < handle
    properties
        %subfolders within directory
        subFolders
        %full paths to subfolders within directory
        subFoldersFullPath
        %number of subfolders
        numFolders
    end
    
    methods
        %returns a string to the ith folder
        function f=folder(obj,i)
            f=char(obj.subFolders{i});
        end
        
        %returns a string to the full path of the ith folder
        function f=folderFullPath(obj,i)
            f=char(obj.subFoldersFullPath{i});
        end
    end
end

