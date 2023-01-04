local variants = {
	main = {
    base     =  '#10100f',
    surface  =  '#181819',
    overlay  =  '#1c1c1d',
    love     =  '#6a3a3a',
    text     =  '#5a4a5a',
    muted    =  '#8b5182',
    subtle   =  '#AC2023',
    gold     =  '#bd2a4c',
    foam     =  '#fb8d5a',
    rose     =  '#ebbcba',
    iris     =  '#8ab3c3',
    pine     =  '#31748f',
		highlight_low = '#21202e',
		highlight_med = '#3a2f3a',
		highlight_high = '#403d52',
		highlight_higher = '#524a52',
		highlight_highest = '#524f67',
		opacity = 0.1,
		none = 'NONE',

    -- Used for inactive buflines.
    --surface_light = '#27222f',--colors.belafonte.blue2,
    surface_light = "#141415",
	},
	moon = {
		base = '#232136',
		surface = '#2a273f',
		overlay = '#393552',
		muted = '#6e6a86',
		subtle = '#908caa',
		text = '#e0def4',
		love = '#eb6f92',
		gold = '#f6c177',
		rose = '#ea9a97',
		pine = '#3e8fb0',
		foam = '#9ccfd8',
		iris = '#c4a7e7',
		highlight_low = '#2a283e',
		highlight_med = '#44415a',
		highlight_high = '#56526e',
		none = 'NONE',
	},
	dawn = {
		base = '#faf4ed',
		surface = '#fffaf3',
		overlay = '#f2e9e1',
		muted = '#9893a5',
		subtle = '#797593',
		text = '#575279',
		love = '#b4637a',
		gold = '#ea9d34',
		rose = '#d7827e',
		pine = '#286983',
		foam = '#56949f',
		iris = '#907aa9',
		highlight_low = '#f4ede8',
		highlight_med = '#dfdad9',
		highlight_high = '#cecacd',
		none = 'NONE',
	},
}

local palette = {}

if vim.o.background == 'light' then
	palette = variants.dawn
else
	palette = variants[(vim.g.rose_pine_variant == 'moon' and 'moon') or 'main']
end

_G.palette = palette

return palette
