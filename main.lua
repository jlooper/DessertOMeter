local json = require("json")
local commands_json

APPID = 'Your_PARSE_API_Key'
RESTAPIKEY = 'Your_PARSE_REST_API_Key'

local function displayFeatured(dessert)
    
    local text = display.newText("Welcome to the Dessert-O-Meter!\nThe cupcake of the day is "..dessert.."", 10, 350, 300, 400, "GillSans", 20 )
    
    local cupcakeImage = display.newImage( "images/"..dessert..".png" )
    cupcakeImage.x = display.contentWidth/2
    cupcakeImage.y = 200

end

local function init()

    local backGround = display.newRoundedRect( 0, 0, display.contentWidth,display.contentHeight,5)
    backGround:setFillColor(155, 89, 182)--amethyst
    backGround.strokeWidth=10
    backGround:setStrokeColor(142, 68, 173)--wysteria


   local function getFeatured(event)

      if event.phase == "ended" then

        local response = event.response
        local decodedResponse = json.decode(response)
        local dessert = decodedResponse.result
        print(dessert)
        displayFeatured(dessert)
      
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

init()



