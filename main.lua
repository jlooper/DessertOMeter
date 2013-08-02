local launchArgs = ...

local json = require("json")
local mime = require("mime")
local commands_json,signInText,usernameText,passwordText,emailText,usernameTxtBox,passwordTxtBox,emailTxtBox,doneButton,pickerWheel,msg,title,takePicButton,uploadButton,saveButton
local widget = require( "widget" )


APPID = 'my_appid'
RESTAPIKEY = 'my_key'


local function displayFeatured(dessert,friendsNum)

    usernameText:removeSelf()
    usernameText = nil
    signInText:removeSelf()
    signInText = nil
    passwordText:removeSelf()
    passwordText = nil
    emailText:removeSelf()
    emailText = nil
    usernameTxtBox:removeSelf()
    usernameTxtBox = nil
    passwordTxtBox:removeSelf()
    passwordTxtBox = nil
    emailTxtBox:removeSelf()
    emailTxtBox = nil
    
    local cupcakeText = display.newText("Welcome to the Dessert-O-Meter!\nThe cupcake of the day is "..dessert..". Guess what, "..friendsNum.." other members like "..dessert.." too!", 10, 310, 300, 400, "GillSans", 20 )
    local cupcakeImage = display.newImage( "images/"..dessert..".png" )
    cupcakeImage.x = display.contentWidth/2
    cupcakeImage.y = 160
   

    local onComplete = function(event)
    local photo = event.target

    local photoGroup = display.newGroup()  
    photoGroup:insert(photo)

    local tmpDirectory = system.TemporaryDirectory
    display.save(photoGroup, "photo.jpg", tmpDirectory) 

        --clear
        cupcakeImage:removeSelf()
        cupcakeImage = nil
        cupcakeText:removeSelf()
        cupcakeText = nil
        saveButton:removeSelf()
        saveButton = nil
        takePicButton:removeSelf()
        takePicButton = nil


        photo.x = display.contentWidth/2
        photo.y = display.contentWidth/2

        local function onUploadButtonRelease(event)
            --upload the pic
            local function callbackFunction(event)
                if event.phase == "ended" then
                    local response = event.response
                    print(response)
                    print(event.status)
                    if event.status == 201 then
                        --alert thanks
                        local alert = native.showAlert( "Thanks!", "Your picture will be added to our gallery!", {"OK"}, onComplete )

                    end
                end
            end

        headers = {}
        headers["X-Parse-Application-Id"] = APPID
        headers["X-Parse-REST-API-Key"] = RESTAPIKEY
        headers["Content-Type"] = "image/jpeg"

        local params = {}
        params.headers = headers
        params.bodyType = "binary"

        network.upload("https://api.parse.com/1/files/photo.jpg","POST",callbackFunction,params,"photo.jpg",system.TemporaryDirectory,"image/jpeg")

    end

        --add a button to allow upload
        uploadButton = widget.newButton
        {
            label = "Upload your photo",
            id = "btnPhoto",
            width=200,
            height=20,
            onRelease = onUploadButtonRelease,
            font = "GillSans"

        }
        uploadButton.x = display.contentWidth/2
        uploadButton.y = 300



    end

    local onTakePicButtonRelease = function(event)
        media.show( media.Camera, onComplete )
    end

    takePicButton = widget.newButton
        {
            label = "Take a picture of your favorite dessert!",
            id = "btnPic",
            width=display.contentWidth,
            height=20,
            onRelease = onTakePicButtonRelease,
            font = "GillSans"

        }
        takePicButton.x = display.contentWidth/2
        takePicButton.y = 450



end

local function init()

    
    local bg = display.newRoundedRect( 0, 0, display.contentWidth,display.contentHeight,3)
    bg:setFillColor(155, 89, 182)--amethyst
    bg.strokeWidth=10
    bg:setStrokeColor(142, 68, 173)--wysteria

    --create login

    local function onReturn( event )
    -- Hide keyboard when the user clicks "Return" in this field
        if ( "submitted" == event.phase ) then
            native.setKeyboardFocus( nil )
        end
    end

    signInText = display.newText("Register for the Dessert-O-Meter!", 30, 20, 300, 400, "GillSans", 20 )
    
    usernameText = display.newText("Username:", 60, 50, 300, 400, "GillSans", 20)
    
    usernameTxtBox = native.newTextField( display.contentWidth/2-100, 80, 200, 20, onReturn)
    
    passwordText = display.newText("Password:", 60, 100, 300, 400, "GillSans", 20)
    
    passwordTxtBox = native.newTextField( display.contentWidth/2-100, 130, 200, 20, onReturn)
    
    passwordTxtBox.isSecure=true
    
    emailText = display.newText("Email:", 60, 150, 300, 400, "GillSans", 20 )
    
    emailTxtBox = native.newTextField( display.contentWidth/2-100, 180, 200, 20, onReturn)
    
    

    local function onSelectFlavorButtonRelease()

        local columnData = 
        { 
            { 
                align = "center",
                width = display.contentWidth,
                startIndex = 1,
                labels = 
                {
                    "","chocolate", "watermelon", "rainbow"
                },
            }
        }

       pickerWheel = widget.newPickerWheel
        {
            top = display.contentHeight-220,
            font = native.systemFontBold,
            columns = columnData
        }

        local function onDoneButtonRelease(event)

            if event.phase == "ended" then

                local pickerValues = pickerWheel:getValues()
                flavorIndex = pickerValues[1].value

                print(flavorIndex)
                                
                    
                    display.remove( pickerWheel )
                    pickerWheel = nil
                       
                    display.remove( doneButton )
                    doneButton = nil

            end

        end

        doneButton = widget.newButton
            {
                defaultFile = "images/btnClose.png",
                overFile="images/btnClose.png",
                onRelease = onDoneButtonRelease,
                width=29,
                height=17,
                font = "GillSans",
                labelColor = {
                  default = { 255, 255, 255 },
                  over = { 120, 53, 128, 255 },
                }

            }
    
            doneButton.x = display.contentWidth/2
            doneButton.y = display.contentHeight-200
        end


       local selectFlavorButton = widget.newButton
        {
            label = "My Favorite Flavor",
            id = "btnSelectFlavor",
            width = 170,
            height = 20,
            onRelease = onSelectFlavorButtonRelease,
            font = "GillSans"

        }
        selectFlavorButton.x = display.contentWidth/2
        selectFlavorButton.y = 230

     local function emailClient(email)
        
        local function emailSent(event)
            if event.phase == "ended" then
                local response = event.response
                print(response)
            end
        end
        
        headers = {}
        headers["X-Parse-Application-Id"] = APPID
        headers["X-Parse-REST-API-Key"] = RESTAPIKEY
        headers["Content-Type"] = "application/json"


        local params = {}

        commands_json =
             {
                ["email"] = email
             }        
 
        postData = json.encode(commands_json)
        
        local params = {}
        params.headers = headers
        params.body = postData

        
        network.request( "https://api.parse.com/1/functions/sendEmail","POST",emailSent,params)   
        
       
    end


    local function onSaveButtonRelease()

        print(usernameTxtBox.text,passwordTxtBox.text,emailTxtBox.text,flavorIndex)

        --register new user

        local function registerNewUser(event)
            
            if event.phase == "ended" then
                local response = event.response
                print(response)
                local t = json.decode(response)
                
                print("this user's fave is "..flavorIndex)
                registerParseDevice(deviceToken,flavorIndex)
                --pass this over to Parse as a channel and while you're at it, do the installation

                if t.error ~= nil then
                    title = "Oops!"
                    msg = t.error
                else
                    title = "Success!"
                    msg = "You're now a registered user of the Dessert-O-Meter!"
                
                    --get featured dessert
                    local function getFeatured(event)

                          if event.phase == "ended" then

                            local response = event.response
                            local decodedResponse = json.decode(response)
                            local dessert = decodedResponse.result
                            print(dessert[1].favorite)
                            print(#dessert)
                            emailClient(emailTxtBox.text)
                            displayFeatured(dessert[1].favorite,#dessert)
                          
                          end
        
                    end
   
                    headers = {}
                    headers["X-Parse-Application-Id"] = APPID
                    headers["X-Parse-REST-API-Key"] = RESTAPIKEY
                    headers["Content-Type"] = "application/json"


                    local params = {}

                    commands_json =
                         {
                            [""] = ""
                         }        
             
                    postData = json.encode(commands_json)
                    
                    local params = {}
                    params.headers = headers
                    params.body = postData

                    network.request( "https://api.parse.com/1/functions/getFeatured","POST",getFeatured,params)   
               
                end
                
                local alert = native.showAlert( "", msg, {"OK"}, onComplete )
 
            end
        end
            
            headers = {}
            headers["X-Parse-Application-Id"] = APPID
            headers["X-Parse-REST-API-Key"] = RESTAPIKEY
            headers["Content-Type"] = "application/json"


        local params = {}

                commands_json =
                     {
                        ["email"] = emailTxtBox.text,
                        ["password"] = passwordTxtBox.text,
                        ["username"] = usernameTxtBox.text,
                        ["favorite"] = flavorIndex

                     }        
         
                postData = json.encode(commands_json)
                
                local params = {}
                params.headers = headers
                params.body = postData



        network.request( "https://api.parse.com/1/users","POST",registerNewUser,params)   

    end
  
 
     saveButton = widget.newButton
        {
            label = "Save",
            id = "btnSave",
            width=80,
            height=20,
            onRelease = onSaveButtonRelease,
            font = "GillSans"

        }
        saveButton.x = display.contentWidth/2
        saveButton.y = 290


        
    end 

function registerParseDevice(deviceToken,flavorIndex)
   
      local function parseNetworkListener(event)
        print(event.response)
      end

        headers = {}
        headers["X-Parse-Application-Id"] = APPID
        headers["X-Parse-REST-API-Key"] = RESTAPIKEY
        headers["Content-Type"] = "application/json"
 
        commands_json =
            {
             ["deviceType"] = "ios",
             ["deviceToken"] = deviceToken,
             ["channels"] = {flavorIndex}            
            }        
 
        postData = json.encode(commands_json)
        
        data = ""
        local params = {}
        params.headers = headers
        params.body = postData
        network.request( "https://api.parse.com/1/installations" ,"POST", parseNetworkListener,  params)
end

local function onNotification( event )

   print("my device id is",event.token)
    
    if event.type == "remoteRegistration" then
        
        if event.token ~= nil then

            --save the deviceToken as a global so we can grab it later
            deviceToken = event.token
            
        else
            print("no token returned, too bad")
        end
        
    elseif event.type == "remote" then
        native.showAlert( "Dessert-O-Meter", event.alert , { "OK" } )
   end

end

local notificationListener = function( event )
   native.setProperty( "applicationIconBadgeNumber", 0 )
end


Runtime:addEventListener( "notification", onNotification )

init()



