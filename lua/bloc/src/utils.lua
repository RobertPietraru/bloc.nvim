local M = {}
 function M.contains_dot(str)
    return string.find(str, "%.")
end

  function M.is_dir(path)
     local f = io.open(path)
     if (f ~= nil) then
     	return not f:read(0) and f:seek("end") ~= 0
     end
     return nil
 end


local function snake_to_camel_case(snake_case_string)
    local camel_case_string = snake_case_string:gsub("_(%w)", function(c)
        return c:upper()
    end)
    return camel_case_string
end

local function capitalize_first_letter(str)
    return str:gsub("^%l", string.upper)
end

local function snake_to_pascal_case(snake_case_string)
	local camel_case = snake_to_camel_case(snake_case_string)
	return capitalize_first_letter(camel_case)
end

 function M.replace_in_template(name_snake_case, template, bloc_path)
	local name_pascal_case = snake_to_pascal_case(name_snake_case);
	print(template)
	print('fuck')
	local file1 = string.gsub(template, "{snake_case}", name_snake_case)
	local file2 = string.gsub(file1, "{pascal_case}", name_pascal_case)
	local file3 = string.gsub(file2, "{pascal_case}", name_pascal_case)
	local file4 = string.gsub(file3, "{bloc_path}", bloc_path)

	return file4
end

 function M.create_file(filename, text)
    local file = io.open(filename, "w")
    if (file ~= nil) then
    	file:write(text)
    	file:close()
    end
end
return M
