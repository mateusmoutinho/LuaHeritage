
return (function ()

    local herigitage = {}
    herigitage.pairs =pairs
    herigitage.setmetatable = setmetatable
    herigitage.type = type
    herigitage.newMetaObject = function (props)
        if not props then
            props = {}
        end
        local selfobject = {}
        selfobject.public = props.public or {}
        selfobject.private = props.private or {}
        selfobject.meta_table =  props.meta_table or {}
        
        selfobject.set_meta_method = function (method_name,callback)
            selfobject.meta_table[method_name] = function (...)
                return callback(selfobject.public,selfobject.private, ...)
            end
            herigitage.setmetatable (selfobject.public, selfobject.meta_table)
        end
        selfobject.meta_extends = function (props)
            for k,v in herigitage.pairs(props) do
                local item = selfobject.meta_table[k]
                if herigitage.type(item) == "function" then
                    selfobject.set_meta_method(k, v)
                else
                    selfobject.meta_table[k] = v
                end
            end
            
        end

        selfobject.set_public_method = function (method_name, callback)
            selfobject.public[method_name] = function (...)
                return callback(selfobject.public,selfobject.private, ...)
            end
        end

        selfobject.public_extends = function (props)
            for k,v in herigitage.pairs(props) do
                local item = selfobject.public[k]
                if herigitage.type(item) == "function" then
                    selfobject.set_public_method(k, v)
                else
                    selfobject.public[k] = v
                end
            end
            
        end

        selfobject.set_private_method = function (method_name, callback)
            selfobject.private[method_name] = function (...)
                return callback(selfobject.public,selfobject.private, ...)
            end
        end
        selfobject.private_extends = function (props)
            for k,v in herigitage.pairs(props) do
                local item = selfobject.private[k]
                if herigitage.type(item) == "function" then
                    selfobject.set_private_method(k, v)
                else
                    selfobject.private[k] = v
                end
            end
            
        end

        return selfobject
    end


    return herigitage



end )()
