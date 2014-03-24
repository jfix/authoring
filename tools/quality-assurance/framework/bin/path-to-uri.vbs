set fso = CreateObject("Scripting.FileSystemObject")
set re = new RegExp

set args = WScript.arguments
fns = args(0)
file_name = fso.GetAbsolutePathName(fns)


re.pattern = "\\"
re.global = True
base_url = "file:///" + re.replace(file_name, "/")


rem We need to know if this is a file or a diretory. This is not always possible so we work by a simple
rem rule. If it exists, check what it is. If it doesn't and there is a period after the last / or no / at
rem rule assume it is a file. Otherwise, assume directory. We append a '/' to directories.

re.Pattern = "\\.+\.[^.]+$"
re.global = False

if fso.FolderExists(file_name) then
	final_url = base_url + "/"
elseif fso.FileExists(file_name) then
	final_url = base_url
elseif re.Test(file_name) then
	final_url = base_url
else
	final_url = base_url + "/"
end if
	

WScript.echo final_url

