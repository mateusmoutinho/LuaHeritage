# LuaHeritage

A lightweight Lua library for creating robust Object-Oriented Programming (OOP) solutions in Lua. LuaHeritage provides encapsulation through public and private properties/methods, making it easy to build maintainable and organized Lua applications.

## Features

- **Public and Private Properties**: Create objects with both public (accessible) and private (encapsulated) data
- **Method Encapsulation**: Define public and private methods with proper access control
- **Metamethod Support**: Extend objects with custom metamethods for operator overloading
- **Simple API**: Easy-to-use interface that doesn't require deep Lua knowledge
- **Lightweight**: Minimal overhead, pure Lua implementation

## Installation

Simply download the [`heregitage.lua`](https://github.com/mateusmoutinho/LuaHeritage/releases/download/1.0.0/heregitage.lua) file and place it in your project directory. Then require it in your Lua code:

```lua
local heregitage = require("heregitage")
```

## Quick Start

Here's a simple example creating a Car object with public and private properties:

```lua
local heregitage = require("heregitage")

-- Define a method that can access both public and private data
local function describe(public, private)
    print("color: " .. public.color)
    print("speed: " .. private.speed)
end 

-- Factory function to create new car objects
local function newCar(color, speed)
    local selfobject = heregitage.newMetaObject()
    
    -- Add public properties (accessible from outside)
    selfobject.public_props_extends({
        color = color,
    })
    
    -- Add private properties (only accessible within methods)
    selfobject.private_props_extends({
        speed = speed,
    })

    -- Add a public method
    selfobject.set_public_method("describe", describe)
    
    return selfobject.public
end

-- Usage
local function main()
    local car = newCar("red", 100)
    car.describe()              -- Outputs: color: red, speed: 100
    print("color:", car.color)  -- Outputs: color: red 
    print("speed:", car.speed)  -- Outputs: speed: nil (private!)
end 

main()
```

## API Reference

### heregitage.newMetaObject(props)

Creates a new meta object that supports public/private encapsulation.

**Parameters:**
- `props` (table, optional): Initial properties
  - `props.public` (table): Initial public properties
  - `props.private` (table): Initial private properties  
  - `props.meta_table` (table): Initial metamethods

**Returns:** A selfobject with the following methods:

- `public_props_extends(props)` - Direct property assignment to public table
- `private_props_extends(props)` - Direct property assignment to private table  
- `meta_props_extends(props)` - Direct property assignment to meta_table
- `public_method_extends(props)` - Method assignment to public table (wraps all as methods)
- `private_method_extends(props)` - Method assignment to private table (wraps all as methods)
- `meta_method_extends(props)` - Method assignment to meta_table (wraps all as metamethods)
- `set_public_method(name, callback)` - Set individual public method
- `set_private_method(name, callback)` - Set individual private method
- `set_meta_method(name, callback)` - Set individual metamethod

### selfobject.public_props_extends(props)

Adds properties directly to the public interface of the object (basic property assignment).

**Parameters:**
- `props` (table): Properties to add to public interface

**Example:**
```lua
selfobject.public_props_extends({
    name = "John",
    age = 30
})
```

### selfobject.private_props_extends(props)

Adds properties directly to the private data of the object (only accessible within methods).

**Parameters:**
- `props` (table): Properties to add to private data

**Example:**
```lua
selfobject.private_props_extends({
    socialSecurityNumber = "123-45-6789",
    salary = 50000
})
```

### selfobject.public_method_extends(props)

Adds multiple public methods at once. All values in props are treated as methods and wrapped with (public, private, ...) signature.

**Parameters:**
- `props` (table): Table of method name-function pairs

**Example:**
```lua
selfobject.public_method_extends({
    getName = function(public, private)
        return public.name
    end,
    greet = function(public, private, greeting)
        return greeting .. " " .. public.name
    end
})
```

### selfobject.private_method_extends(props)

Adds multiple private methods at once. All values in props are treated as methods and wrapped with (public, private, ...) signature.

**Parameters:**
- `props` (table): Table of method name-function pairs

**Example:**
```lua
selfobject.private_method_extends({
    calculateTax = function(public, private)
        return private.salary * 0.2
    end,
    validateData = function(public, private)
        return public.name ~= nil and private.salary > 0
    end
})
```

### selfobject.set_public_method(method_name, callback)

Defines a public method that can be called from outside the object.

**Parameters:**
- `method_name` (string): Name of the method
- `callback` (function): Method implementation. Receives `(public, private, ...)` as parameters

**Example:**
```lua
selfobject.set_public_method("getName", function(public, private)
    return public.name
end)
```

### selfobject.set_private_method(method_name, callback)

Defines a private method (stored in private data, only accessible within other methods).

**Parameters:**
- `method_name` (string): Name of the method
- `callback` (function): Method implementation. Receives `(public, private, ...)` as parameters

**Example:**
```lua
selfobject.set_private_method("calculateTax", function(public, private)
    return private.salary * 0.2
end)
```

### selfobject.set_meta_method(method_name, callback)

Defines a metamethod for operator overloading and special behaviors.

**Parameters:**
- `method_name` (string): Metamethod name (e.g., "__add", "__tostring")
- `callback` (function): Method implementation. Receives `(public, private, ...)` as parameters

**Example:**
```lua
selfobject.set_meta_method("__tostring", function(public, private)
    return public.name .. " (" .. public.age .. ")"
end)
```

### selfobject.meta_props_extends(props)

Adds properties directly to the meta_table.

**Parameters:**
- `props` (table): Properties to add to meta_table

**Example:**
```lua
selfobject.meta_props_extends({
    __index = someTable,
    __newindex = someFunction
})
```

### selfobject.meta_method_extends(props)

Adds multiple metamethods at once. All values in props are treated as methods and wrapped with (public, private, ...) signature.

**Parameters:**
- `props` (table): Table of metamethod name-function pairs

**Example:**
```lua
selfobject.meta_method_extends({
    __add = function(public, private, other)
        return public.value + other.value
    end,
    __tostring = function(public, private)
        return tostring(public.value)
    end
})
```

## Advanced Examples

### Understanding the Difference: `*_props_extends` vs `*_method_extends`

The API now clearly distinguishes between property assignment and method assignment:

```lua
local heregitage = require("heregitage")

local function newExample()
    local selfobject = heregitage.newMetaObject()
    
    -- Use *_props_extends for direct property assignment (data)
    selfobject.public_props_extends({
        name = "John",           -- string data
        age = 30,               -- number data
        isActive = true         -- boolean data
    })
    
    selfobject.private_props_extends({
        id = "12345",           -- private data
        config = { debug = true } -- table data
    })
    
    -- Use *_method_extends for functions that should be methods
    selfobject.public_method_extends({
        getName = function(public, private)
            return public.name
        end,
        greet = function(public, private, greeting)
            return greeting .. " " .. public.name
        end,
        isAdult = function(public, private)
            return public.age >= 18
        end
    })
    
    selfobject.private_method_extends({
        validateId = function(public, private)
            return private.id ~= nil and #private.id > 0
        end
    })
    
    -- Meta methods should also use method_extends
    selfobject.meta_method_extends({
        __tostring = function(public, private)
            return public.name .. " (" .. public.age .. ")"
        end
    })
    
    return selfobject.public
end

-- Usage
local obj = newExample()
print("Direct property access:", obj.name)  -- "John"
print("Method call:", obj.getName())        -- "John"  
print("Method with params:", obj.greet("Hello"))  -- "Hello John"
print("String representation:", tostring(obj))    -- "John (30)"
```

### Example 1: Bank Account with Private Balance

```lua
local heregitage = require("heregitage")

local function newBankAccount(initialBalance, accountHolder)
    local selfobject = heregitage.newMetaObject()
    
    selfobject.public_props_extends({
        accountHolder = accountHolder,
        accountNumber = math.random(100000, 999999)
    })
    
    selfobject.private_props_extends({
        balance = initialBalance or 0
    })
    
    selfobject.set_public_method("deposit", function(public, private, amount)
        if amount > 0 then
            private.balance = private.balance + amount
            return true
        end
        return false
    end)
    
    selfobject.set_public_method("withdraw", function(public, private, amount)
        if amount > 0 and amount <= private.balance then
            private.balance = private.balance - amount
            return true
        end
        return false
    end)
    
    selfobject.set_public_method("getBalance", function(public, private)
        return private.balance
    end)
    
    return selfobject.public
end

-- Usage
local account = newBankAccount(1000, "John Doe")
print(account.accountHolder)  -- "John Doe"
print(account.balance)        -- nil (private!)
print(account.getBalance())   -- 1000
account.deposit(500)
print(account.getBalance())   -- 1500
```

### Example 2: Vector Math with Operator Overloading

```lua
local heregitage = require("heregitage")

local function newVector(x, y)
    local selfobject = heregitage.newMetaObject()
    
    selfobject.public_props_extends({
        x = x or 0,
        y = y or 0
    })
    
    -- Vector addition
    selfobject.set_meta_method("__add", function(public, private, other)
        return newVector(public.x + other.x, public.y + other.y)
    end)
    
    -- Vector string representation
    selfobject.set_meta_method("__tostring", function(public, private)
        return "Vector(" .. public.x .. ", " .. public.y .. ")"
    end)
    
    selfobject.set_public_method("magnitude", function(public, private)
        return math.sqrt(public.x^2 + public.y^2)
    end)
    
    return selfobject.public
end

-- Usage
local v1 = newVector(3, 4)
local v2 = newVector(1, 2)
local v3 = v1 + v2              -- Uses __add metamethod
print(v3)                       -- Uses __tostring metamethod
print(v1.magnitude())           -- 5.0
```

### Example 3: Inheritance-like Pattern

```lua
local heregitage = require("heregitage")

-- Base "class" for animals
local function newAnimal(name)
    local selfobject = heregitage.newMetaObject()
    
    selfobject.public_props_extends({
        name = name
    })
    
    selfobject.set_public_method("speak", function(public, private)
        return public.name .. " makes a sound"
    end)
    
    return selfobject
end

-- "Derived class" for dogs
local function newDog(name, breed)
    local selfobject = newAnimal(name)  -- Start with animal base
    
    selfobject.public_props_extends({
        breed = breed
    })
    
    -- Override the speak method
    selfobject.set_public_method("speak", function(public, private)
        return public.name .. " barks!"
    end)
    
    selfobject.set_public_method("fetch", function(public, private)
        return public.name .. " fetches the ball"
    end)
    
    return selfobject.public
end

-- Usage
local dog = newDog("Buddy", "Golden Retriever")
print(dog.speak())    -- "Buddy barks!"
print(dog.fetch())    -- "Buddy fetches the ball"
print(dog.breed)      -- "Golden Retriever"
```

## Best Practices

### 1. Use Factory Functions
Always create factory functions to construct your objects. This provides a clean interface and encapsulates the object creation logic.

```lua
-- Good
local function newPerson(name, age)
    local selfobject = heregitage.newMetaObject()
    -- ... setup code
    return selfobject.public
end

-- Avoid
local person = heregitage.newMetaObject()
-- ... direct manipulation
```

### 2. Keep Private Data Truly Private
Only access private data through methods. Never expose private properties through public methods unless absolutely necessary.

```lua
-- Good
selfobject.set_public_method("getAge", function(public, private)
    return private.age
end)

-- Avoid exposing private data directly
selfobject.public_props_extends({
    getPrivateData = function() return selfobject.private end
})
```

### 3. Use Meaningful Method Names
Choose descriptive names that clearly indicate what the method does.

```lua
-- Good
selfobject.set_public_method("calculateMonthlyPayment", ...)
selfobject.set_public_method("isEligibleForDiscount", ...)

-- Avoid
selfobject.set_public_method("calc", ...)
selfobject.set_public_method("check", ...)
```

### 4. Validate Input Parameters
Always validate parameters in public methods to ensure data integrity.

```lua
selfobject.set_public_method("setAge", function(public, private, age)
    if type(age) ~= "number" or age < 0 then
        error("Age must be a positive number")
    end
    private.age = age
end)
```

### 5. Use Metamethods Judiciously
Only implement metamethods when they provide clear, intuitive behavior for your objects.

```lua
-- Good: Mathematical operations on numbers/vectors
selfobject.set_meta_method("__add", ...)

-- Good: String representation
selfobject.set_meta_method("__tostring", ...)

-- Avoid: Confusing or unexpected behavior
selfobject.set_meta_method("__sub", function() return "hello" end)  -- confusing!
```

## Common Patterns

### Singleton Pattern
```lua
local function createSingleton()
    local instance = nil
    
    return function()
        if not instance then
            local selfobject = heregitage.newMetaObject()
            -- ... setup singleton
            instance = selfobject.public
        end
        return instance
    end
end

local getSingleton = createSingleton()
local obj1 = getSingleton()
local obj2 = getSingleton()
-- obj1 and obj2 are the same instance
```

### Observer Pattern
```lua
local function newObservable()
    local selfobject = heregitage.newMetaObject()
    
    selfobject.private_props_extends({
        observers = {}
    })
    
    selfobject.set_public_method("addObserver", function(public, private, observer)
        table.insert(private.observers, observer)
    end)
    
    selfobject.set_public_method("notifyObservers", function(public, private, data)
        for _, observer in ipairs(private.observers) do
            observer(data)
        end
    end)
    
    return selfobject.public
end
```

## Troubleshooting

### Common Issues

**Q: My private properties are accessible from outside**
A: Make sure you're returning `selfobject.public`, not `selfobject`. Private properties are only accessible within methods.

**Q: Methods aren't working**
A: Ensure you're calling methods with the colon syntax (`object:method()`) or dot syntax with explicit self parameter.

**Q: Metamethods not working**
A: Remember that metamethods are automatically called by Lua. You don't call them directly. For example, `__add` is called when you use the `+` operator.

**Q: Getting "attempt to call a nil value" errors**
A: Check that you've properly set the method using `set_public_method()` and that you're calling it on the public interface.

### Performance Considerations

- LuaHeritage adds minimal overhead to your objects
- Method calls have a small performance cost due to the wrapper functions
- For performance-critical code, consider using plain Lua tables if you don't need encapsulation
- Private data access is just as fast as regular table access within methods

## Contributing

This library aims to stay simple and focused. If you have suggestions for improvements or find bugs, please open an issue or submit a pull request.

## License

See the LICENSE file for license information.
