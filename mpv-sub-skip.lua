--[[
    The plugin will skip the subtitles with these words in them.
    At first I thought just looking for the "full" word would be enough but no.
    Some anime I have put just "English" in the real subtitles.
    It's more precise to skip the subtitles with "sign" and "song".
]]


-- Array of keywords to check against subtitle titles
local keywordsArray = {"sign", "song"}
local can_log = true

-- Log function: log to both terminal and MPV OSD (On-Screen Display)
function log(string, secs)
    if not can_log then return end
    secs = secs or 2.5  -- secs defaults to 2.5 when secs parameter is absent
    -- mp.msg.warn(string)          -- This logs to the terminal
    mp.osd_message(string, secs) -- This logs to MPV screen
end

-- ugly ass function to check if string contains any keywords
function containsKeyword(title)
    for _, keyword in ipairs(keywordsArray) do
        if type(title) == "string" and string.find(string.lower(title), string.lower(keyword)) then
            return true
        end
    end
    return false
end

-- Lists the subtitles and puts them in a table.
-- index does not represent the "sid", subtitle id, therefore I had to put the 4th variable sid_index
function listSubtitles()
    local subtitles = mp.get_property_native("track-list")
    local subtitleList = {}
    local current_sub_id = 1
    for i, track in ipairs(subtitles) do
        if track["type"] == "sub" then
            local title = track["title"]
            if type(title) == "string" then
                local subtitleInfo = {
                    index = i,
                    title = title,
                    language = track["lang"] or "Unknown",
                    sid_index = current_sub_id
                }
                table.insert(subtitleList, subtitleInfo)
                -- print(i .. ": " .. subtitleInfo.title .. " (" .. subtitleInfo.language .. ")")
                current_sub_id = current_sub_id + 1
            end
        end
    end

    return subtitleList
end

function setSubtitle(index)
    mp.set_property_native("sid", index)
    -- print("Subtitle changed to: " .. mp.get_property_native("sid"))
end

function setSubtitleByKeyword()
    local subtitles = listSubtitles()

    for _, subtitleInfo in ipairs(subtitles) do
        if not containsKeyword(subtitleInfo.title) then
            setSubtitle(subtitleInfo.sid_index)
            log("[FG] Auto switched to number " .. subtitleInfo.sid_index .. " : " .. subtitleInfo.title)
            return  -- Stop after setting the first matching subtitle
        end
    end

    -- print("No matching subtitles found.")
end

-- Triggered when the file is loaded
function onFileLoaded()
    setSubtitleByKeyword()
end

mp.register_event("file-loaded", onFileLoaded)

