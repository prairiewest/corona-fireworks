
-- config.lua
local aspectRatio = display.pixelHeight / display.pixelWidth

application =
{
    content =
    {
            width = 640,
            height = math.ceil(640 * aspectRatio),
            scale = "letterbox",
			fps = 60,
			imageSuffix =
			{
                ["@2x"] = 1.5,
				["@4x"] = 3.5,
			},
    },
    license =
    {
        google =
        {
            key = "",
        },
    },
}
