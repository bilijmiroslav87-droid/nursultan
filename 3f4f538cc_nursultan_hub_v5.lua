-- NURSULTAN HUB | Mobile Edition (compressed — дизайн не тронут)
-- Оригинал обрывался в section:AddToggle на "Text = mname"; тумблер дописан (помечено ниже).

local TS  = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RNS = game:GetService("RunService")
local ST  = game:GetService("Stats")
local PL  = game:GetService("Players")
local WS  = game:GetService("Workspace")
local LG  = game:GetService("Lighting")
local VU  = game:GetService("VirtualUser")

local LP = PL.LocalPlayer
if not LP then PL:GetPropertyChangedSignal("LocalPlayer"):Wait() LP = PL.LocalPlayer end

local LOGO = "rbxassetid://139568612294283"

local I, C, U2, U1 = Instance.new, Color3.fromRGB, UDim2.new, UDim.new

local function N(class, props)
	local o = I(class)
	local par
	for k, v in next, props or {} do
		if k == "Parent" then par = v else o[k] = v end
	end
	o.Parent = par
	return o
end
local function R(o, r) return N("UICorner", { CornerRadius = U1(0, r), Parent = o }) end

local TP
pcall(function() if gethui then TP = gethui() end end)
TP = TP or LP:WaitForChild("PlayerGui")
if TP:FindFirstChild("NursultanHubMobile") then TP.NursultanHubMobile:Destroy() end

local SG = N("ScreenGui", {
	Name = "NursultanHubMobile", ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999, Parent = TP,
})

local Flags, Modules = {}, {}
local F = {}

local T = {
	Background = C(12, 9, 11), CardBg = C(18, 13, 16), PillBg = C(16, 12, 14),
	SidebarActive = C(27, 16, 19), Border = C(36, 24, 28), BorderActive = C(90, 36, 42),
	Accent = C(246, 92, 82), AccentSoft = C(255, 165, 155), AccentDark = C(130, 40, 42),
	TextPrimary = C(235, 235, 235), TextMuted = C(120, 110, 115), TextDim = C(72, 64, 68),
	Divider = C(48, 36, 40), ToggleOff = C(36, 28, 32), KnobOff = C(78, 68, 73), KnobOn = C(255, 255, 255),
}

local IC = {
	Search = "rbxassetid://7733911828", Menu = "rbxassetid://7733993211",
	Combat = "rbxassetid://7734053426", Movement = "rbxassetid://7733799901",
	Visuals = "rbxassetid://7733774602", Misc = "rbxassetid://7734056411",
	User = "rbxassetid://7733954760", Chart = "rbxassetid://7733749837",
	Clock = "rbxassetid://7733734762", Compass = "rbxassetid://7733720755",
	Signal = "rbxassetid://7734058495", Speed = "rbxassetid://7733799901",
}

local TF = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Перетаскивание: мышь + тач
local function DRAG(gui, handle)
	handle = handle or gui
	local dragging, di, ds, sp
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging, ds, sp = true, input.Position, gui.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			di = input
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if input == di and dragging then
			local d = input.Position - ds
			gui.Position = U2(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
		end
	end)
end

-- 1. HUD WATERMARK
local HC = N("Frame", {
	Name = "HudContainer", Size = U2(0, 600, 0, 50),
	Position = U2(0, 16, 0, 48), BackgroundTransparency = 1, Parent = SG,
})
N("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = U1(0, 4), Parent = HC })

local function row(name, h, order)
	local r = N("Frame", { Name = name, Size = U2(1, 0, 0, h), BackgroundTransparency = 1, LayoutOrder = order, Parent = HC })
	N("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center, Padding = U1(0, 5), Parent = r,
	})
	return r
end

local function pill(parent, order)
	local p = N("Frame", {
		AutomaticSize = Enum.AutomaticSize.X, Size = U2(0, 0, 1, 0),
		BackgroundColor3 = T.PillBg, BorderSizePixel = 0, LayoutOrder = order, Parent = parent,
	})
	R(p, 5)
	N("UIStroke", { Color = T.Border, Thickness = 1, Parent = p })
	N("UIPadding", { PaddingLeft = U1(0, 6), PaddingRight = U1(0, 6), Parent = p })
	N("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center, Padding = U1(0, 5), Parent = p,
	})
	return p
end

local function div(parent, order)
	N("Frame", { Size = U2(0, 1, 0, 10), BackgroundColor3 = T.Divider, BorderSizePixel = 0, LayoutOrder = order, Parent = parent })
end

local function txt(parent, text, muted, order)
	return N("TextLabel", {
		AutomaticSize = Enum.AutomaticSize.X, Size = U2(0, 0, 1, 0), BackgroundTransparency = 1,
		Text = text, Font = Enum.Font.GothamMedium, TextSize = 10.5,
		TextColor3 = muted and T.TextMuted or T.TextPrimary, LayoutOrder = order, Parent = parent,
	})
end

local function ico(parent, id, order)
	return N("ImageLabel", {
		Size = U2(0, 11, 0, 11), BackgroundTransparency = 1, Image = id,
		ScaleType = Enum.ScaleType.Fit, ImageColor3 = T.Accent, LayoutOrder = order, Parent = parent,
	})
end

local TR, BR = row("TopRow", 22, 1), row("BottomRow", 22, 2)

local pBrand = pill(TR, 1)
local LW = N("Frame", { Size = U2(0, 20, 0, 20), BackgroundTransparency = 1, LayoutOrder = 1, Parent = pBrand })
N("ImageLabel", {
	Size = U2(2, 0, 2, 0), Position = U2(-0.5, 0, -0.5, 0), BackgroundTransparency = 1,
	Image = "rbxassetid://5028857084", ImageColor3 = T.Accent, ImageTransparency = 0.65, ZIndex = 1, Parent = LW,
})
local BL = N("ImageLabel", {
	Size = U2(1.35, 0, 1.35, 0), Position = U2(-0.175, 0, -0.175, 0), BackgroundTransparency = 1,
	Image = LOGO, ScaleType = Enum.ScaleType.Fit, ZIndex = 2, Parent = LW,
})
N("UIGradient", {
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, T.AccentSoft), ColorSequenceKeypoint.new(0.45, T.Accent),
		ColorSequenceKeypoint.new(1, C(165, 32, 42)),
	}), Rotation = -35, Parent = BL,
})
div(pBrand, 2)
local BT = txt(pBrand, "nursultan", false, 3)
N("UIGradient", {
	Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, T.AccentSoft), ColorSequenceKeypoint.new(1, T.Accent) }),
	Parent = BT,
})

local pStats = pill(TR, 2)
ico(pStats, IC.User, 1)
txt(pStats, LP.Name:lower(), false, 2)
div(pStats, 3)
ico(pStats, IC.Chart, 4)
local FPS = txt(pStats, "0 fps", false, 5)
div(pStats, 6)
ico(pStats, IC.Clock, 7)
local TIME = txt(pStats, "00:00:00", false, 8)

local pPos = pill(BR, 1)
ico(pPos, IC.Compass, 1)
div(pPos, 2)
local POS = txt(pPos, "0, 0, 0", false, 3)

local pPing = pill(BR, 2)
ico(pPing, IC.Signal, 1)
div(pPing, 2)
local PING = txt(pPing, "0 ping", false, 3)

local pSpeed = pill(BR, 3)
ico(pSpeed, IC.Speed, 1)
div(pSpeed, 2)
local SPD = txt(pSpeed, "0 bps", false, 3)

-- ArrayList (активные функции, справа сверху): градиент, сортировка по ширине, плавное появление
local AL = N("Frame", {
	AnchorPoint = Vector2.new(1, 0), Position = U2(1, -10, 0, 12),
	Size = U2(0, 220, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
	BackgroundTransparency = 1, Parent = SG,
})
N("UIListLayout", {
	Padding = U1(0, 2), HorizontalAlignment = Enum.HorizontalAlignment.Right,
	SortOrder = Enum.SortOrder.LayoutOrder, Parent = AL,
})

local ALRows = {} -- flag -> { row=, label= }
local TextService = game:GetService("TextService")

local function alColor(i)
	-- мягкий градиент от AccentSoft к Accent по позиции в списке
	return T.AccentSoft:Lerp(T.Accent, math.clamp((i - 1) / 7, 0, 1))
end

F.RefreshArrayList = function()
	-- собрать активные
	local active = {}
	for flag, mod in pairs(Modules) do
		if Flags[flag] then
			local w = TextService:GetTextSize(mod.name:upper(), 11, Enum.Font.GothamBold, Vector2.new(400, 20)).X
			active[#active + 1] = { flag = flag, name = mod.name:upper(), w = w + 22 }
		end
	end
	table.sort(active, function(a, b) return a.w > b.w end)

	local alive = {}
	for i, a in ipairs(active) do
		alive[a.flag] = true
		local r = ALRows[a.flag]
		if not r then
			local holder = N("Frame", {
				Size = U2(1, 0, 0, 20), BackgroundTransparency = 1, ClipsDescendants = true, Parent = AL,
			})
			local row = N("Frame", {
				AnchorPoint = Vector2.new(1, 0), Position = U2(1, 40, 0, 0), Size = U2(0, a.w, 1, 0),
				BackgroundColor3 = T.PillBg, BackgroundTransparency = 0.12, BorderSizePixel = 0, Parent = holder,
			})
			R(row, 4)
			local bar = N("Frame", {
				AnchorPoint = Vector2.new(1, 0), Position = U2(1, 0, 0, 3), Size = U2(0, 2, 1, -6),
				BackgroundColor3 = T.Accent, BorderSizePixel = 0, Parent = row,
			})
			R(bar, 1)
			local lbl = N("TextLabel", {
				Position = U2(0, 0, 0, 0), Size = U2(1, -9, 1, 0), BackgroundTransparency = 1,
				Font = Enum.Font.GothamBold, Text = a.name, TextSize = 11, TextColor3 = T.Accent,
				TextXAlignment = Enum.TextXAlignment.Right, Parent = row,
			})
			N("UIStroke", { Color = T.BorderActive, Thickness = 1, Transparency = 0.45, Parent = row })
			TS:Create(row, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = U2(1, 0, 0, 0) }):Play()
			r = { holder = holder, row = row, bar = bar, lbl = lbl }
			ALRows[a.flag] = r
		end
		r.holder.LayoutOrder = i
		r.row.Size = U2(0, a.w, 1, 0)
		local col = alColor(i)
		r.lbl.TextColor3 = col
		r.bar.BackgroundColor3 = col
	end

	-- убрать выключенные (с анимацией ухода)
	for flag, r in pairs(ALRows) do
		if not alive[flag] then
			ALRows[flag] = nil
			local tw = TS:Create(r.row, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = U2(1, 40, 0, 0) })
			tw:Play()
			tw.Completed:Connect(function() if r.holder then r.holder:Destroy() end end)
		end
	end
end

-- Live HUD updates
do
	local n, t0 = 0, os.clock()
	local lastP, lastT = Vector3.zero, os.clock()
	RNS.RenderStepped:Connect(function()
		n += 1
		local now = os.clock()
		if now - t0 >= 1 then FPS.Text = n .. " fps" n, t0 = 0, now end
		TIME.Text = os.date("%H:%M:%S")
		pcall(function() PING.Text = math.floor(ST.Network.ServerStatsItem["Data Ping"]:GetValue()) .. " ping" end)
		local ch = LP.Character
		local hr = ch and ch:FindFirstChild("HumanoidRootPart")
		if hr then
			local p = hr.Position
			POS.Text = string.format("%d, %d, %d", p.X, p.Y, p.Z)
			local dt = now - lastT
			if dt >= 0.1 then
				SPD.Text = string.format("%.1f bps", (Vector3.new(p.X, 0, p.Z) - Vector3.new(lastP.X, 0, lastP.Z)).Magnitude / dt)
				lastP, lastT = p, now
			end
		else
			POS.Text, SPD.Text = "0, 0, 0", "0.0 bps"
		end
	end)
end

-- ============================================================
-- 2. МЕНЮ (компакт 420x280, вкладки, закрытие, FAB)
-- ============================================================
local Main = N("Frame", {
	Name = "MainFrame", Size = U2(0, 420, 0, 280), Position = U2(0.5, -210, 0.5, -140),
	BackgroundColor3 = T.Background, BorderSizePixel = 0, Parent = SG,
})
R(Main, 10)
N("UIStroke", { Color = T.Border, Thickness = 1.2, Parent = Main })
N("ImageLabel", {
	Name = "GlowBackdrop", BackgroundTransparency = 1, Position = U2(0, -30, 0, -30), Size = U2(1, 60, 1, 60),
	ZIndex = 0, Image = "rbxassetid://5028857084", ImageColor3 = T.AccentDark, ImageTransparency = 0.83,
	ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(24, 24, 276, 276), Parent = Main,
})

local TopBar = N("Frame", { Size = U2(1, 0, 0, 36), BackgroundTransparency = 1, Parent = Main })
DRAG(Main, TopBar)

local LH = N("Frame", { Size = U2(0, 34, 0, 34), Position = U2(0, 8, 0, 1), BackgroundTransparency = 1, Parent = TopBar })
N("ImageLabel", {
	Size = U2(2.1, 0, 2.1, 0), Position = U2(-0.55, 0, -0.55, 0), BackgroundTransparency = 1,
	Image = "rbxassetid://5028857084", ImageColor3 = T.Accent, ImageTransparency = 0.58, ZIndex = 1, Parent = LH,
})
local ML = N("ImageLabel", {
	Size = U2(1, 0, 1, 0), BackgroundTransparency = 1, Image = LOGO, ScaleType = Enum.ScaleType.Fit, ZIndex = 3, Parent = LH,
})
N("UIGradient", {
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, C(255, 175, 165)), ColorSequenceKeypoint.new(0.45, T.Accent),
		ColorSequenceKeypoint.new(1, C(165, 32, 42)),
	}), Rotation = -35, Parent = ML,
})

local SB = N("Frame", {
	Size = U2(0, 190, 0, 24), Position = U2(0, 52, 0, 6), BackgroundColor3 = T.CardBg, BorderSizePixel = 0, Parent = TopBar,
})
R(SB, 6)
N("UIStroke", { Color = T.Border, Thickness = 0.8, Parent = SB })
N("ImageLabel", {
	Size = U2(0, 12, 0, 12), Position = U2(0, 8, 0.5, -6), BackgroundTransparency = 1,
	Image = IC.Search, ImageColor3 = T.TextMuted, Parent = SB,
})
local SI = N("TextBox", {
	PlaceholderText = "Search functions...", PlaceholderColor3 = T.TextMuted, TextColor3 = T.TextPrimary,
	Font = Enum.Font.Gotham, TextSize = 10, Position = U2(0, 26, 0, 0), Size = U2(1, -30, 1, 0),
	BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Text = "", ClearTextOnFocus = false, Parent = SB,
})

local CB = N("TextButton", {
	Size = U2(0, 24, 0, 24), Position = U2(1, -32, 0, 6), BackgroundColor3 = T.CardBg, BorderSizePixel = 0,
	Text = "X", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = T.TextMuted, AutoButtonColor = false, Parent = TopBar,
})
R(CB, 6)
N("UIStroke", { Color = T.Border, Thickness = 0.8, Parent = CB })
CB.MouseEnter:Connect(function() TS:Create(CB, TF, { TextColor3 = T.Accent }):Play() end)
CB.MouseLeave:Connect(function() TS:Create(CB, TF, { TextColor3 = T.TextMuted }):Play() end)

local Fab = N("ImageButton", {
	Name = "Fab", Size = U2(0, 44, 0, 44), Position = U2(0, 12, 0.6, 0), BackgroundColor3 = T.PillBg, BorderSizePixel = 0,
	Image = LOGO, ScaleType = Enum.ScaleType.Fit, Visible = false, Parent = SG,
})
R(Fab, 22)
N("UIStroke", { Color = T.BorderActive, Thickness = 1.5, Parent = Fab })
N("UIGradient", {
	Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, T.AccentSoft), ColorSequenceKeypoint.new(1, T.Accent) }),
	Rotation = -35, Parent = Fab,
})
do
	local down, moved, ds, sp
	Fab.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
			down, moved, ds, sp = true, false, i.Position, Fab.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then
					down = false
					if not moved then Main.Visible, Fab.Visible = true, false end
				end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if down and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
			local d = i.Position - ds
			if d.Magnitude > 6 then moved = true end
			if moved then Fab.Position = U2(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end
		end
	end)
end
CB.MouseButton1Click:Connect(function() Main.Visible, Fab.Visible = false, true end)

local SBar = N("Frame", { Size = U2(0, 96, 1, -44), Position = U2(0, 8, 0, 40), BackgroundTransparency = 1, Parent = Main })
N("UIListLayout", { Padding = U1(0, 3), SortOrder = Enum.SortOrder.LayoutOrder, Parent = SBar })
local CTN = N("Frame", { Position = U2(0, 112, 0, 40), Size = U2(1, -120, 1, -48), BackgroundTransparency = 1, Parent = Main })

local activeTab
local Items = {}

local function selectTab(e)
	if activeTab == e then return end
	local o = activeTab
	TS:Create(o.Btn, TF, { BackgroundTransparency = 1 }):Play()
	TS:Create(o.Stroke, TF, { Transparency = 1 }):Play()
	TS:Create(o.Icon, TF, { ImageColor3 = T.TextMuted }):Play()
	TS:Create(o.Title, TF, { TextColor3 = T.TextMuted }):Play()
	o.Page.Visible = false
	TS:Create(e.Btn, TF, { BackgroundTransparency = 0 }):Play()
	TS:Create(e.Stroke, TF, { Transparency = 0 }):Play()
	TS:Create(e.Icon, TF, { ImageColor3 = T.Accent }):Play()
	TS:Create(e.Title, TF, { TextColor3 = T.TextPrimary }):Play()
	e.Page.Visible = true
	activeTab = e
end

local function addTab(name, icon, order, default)
	local btn = N("TextButton", {
		Size = U2(1, 0, 0, 26), LayoutOrder = order, Text = "", AutoButtonColor = false,
		BackgroundColor3 = T.SidebarActive, BackgroundTransparency = default and 0 or 1, Parent = SBar,
	})
	R(btn, 6)
	local st = N("UIStroke", { Color = T.BorderActive, Thickness = 1, Transparency = default and 0 or 1, Parent = btn })
	local ic = N("ImageLabel", {
		Size = U2(0, 13, 0, 13), Position = U2(0, 8, 0.5, -6.5), BackgroundTransparency = 1, Image = icon,
		ImageColor3 = default and T.Accent or T.TextMuted, Parent = btn,
	})
	local tt = N("TextLabel", {
		Size = U2(1, -28, 1, 0), Position = U2(0, 26, 0, 0), BackgroundTransparency = 1, Text = name,
		Font = Enum.Font.GothamMedium, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = default and T.TextPrimary or T.TextMuted, Parent = btn,
	})
	local page = N("ScrollingFrame", {
		Name = name, Size = U2(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
		ScrollBarThickness = 2, ScrollBarImageColor3 = T.BorderActive,
		AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = U2(0, 0, 0, 0), Visible = default or false, Parent = CTN,
	})
	N("UIListLayout", { Padding = U1(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = page })
	N("UIPadding", { PaddingRight = U1(0, 4), Parent = page })
	local e = { Btn = btn, Stroke = st, Icon = ic, Title = tt, Page = page }
	btn.MouseButton1Click:Connect(function() selectTab(e) end)
	if default then activeTab = e end
	return e
end

local order = 0
local function nextOrder() order += 1 return order end

local function Header(tab, text)
	N("TextLabel", {
		Size = U2(1, 0, 0, 16), BackgroundTransparency = 1, Text = text:upper(), Font = Enum.Font.GothamBold,
		TextSize = 9, TextColor3 = T.Accent, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = nextOrder(),
		Parent = tab.Page,
	})
end

local function Card(tab, name)
	local c = N("Frame", {
		Size = U2(1, 0, 0, 30), LayoutOrder = nextOrder(), BackgroundColor3 = T.PillBg,
		BorderSizePixel = 0, ClipsDescendants = true, Parent = tab.Page,
	})
	R(c, 6)
	N("UIStroke", { Color = T.Border, Thickness = 1, Parent = c })
	local lbl = N("TextLabel", {
		Position = U2(0, 10, 0, 0), Size = U2(0.6, 0, 0, 30), BackgroundTransparency = 1, Text = name,
		Font = Enum.Font.GothamMedium, TextSize = 10.5, TextColor3 = T.TextPrimary,
		TextXAlignment = Enum.TextXAlignment.Left, Parent = c,
	})
	table.insert(Items, { card = c, name = name:lower() })
	return c, lbl
end

local Setters = {} -- flag -> function(bool) для программного переключения (конфиги/биндов)

local function Toggle(tab, name, flag, cb)
	Flags[flag] = false
	Modules[flag] = { name = name }
	local c = Card(tab, name)
	local sw = N("Frame", {
		AnchorPoint = Vector2.new(1, 0), Position = U2(1, -8, 0, 7), Size = U2(0, 32, 0, 16),
		BackgroundColor3 = T.ToggleOff, BorderSizePixel = 0, Parent = c,
	})
	R(sw, 8)
	local k = N("Frame", { Size = U2(0, 12, 0, 12), Position = U2(0, 2, 0.5, -6), BackgroundColor3 = T.KnobOff, BorderSizePixel = 0, Parent = sw })
	R(k, 6)
	local hit = N("TextButton", { Size = U2(1, 0, 0, 30), BackgroundTransparency = 1, Text = "", Parent = c })
	local function set(v)
		Flags[flag] = v
		TS:Create(sw, TF, { BackgroundColor3 = v and T.Accent or T.ToggleOff }):Play()
		TS:Create(k, TF, { BackgroundColor3 = v and T.KnobOn or T.KnobOff, Position = U2(0, v and 18 or 2, 0.5, -6) }):Play()
		F.RefreshArrayList()
		if cb then
			local ok, err = pcall(cb, v)
			if not ok then warn("[NH] " .. name .. ": " .. tostring(err)) end
		end
	end
	Setters[flag] = set
	hit.MouseButton1Click:Connect(function() set(not Flags[flag]) end)
	return c
end

local function Button(tab, name, cb)
	local c, lbl = Card(tab, name)
	local b = N("TextButton", { Size = U2(1, 0, 0, 30), BackgroundTransparency = 1, Text = "", Parent = c })
	b.MouseButton1Click:Connect(function() cb(lbl) end)
end

local function Slider(tab, name, flag, min, max, def, cb)
	Flags[flag] = def
	local c = Card(tab, name)
	c.Size = U2(1, 0, 0, 44)
	local val = N("TextLabel", {
		AnchorPoint = Vector2.new(1, 0), Position = U2(1, -10, 0, 0), Size = U2(0.3, 0, 0, 30), BackgroundTransparency = 1,
		Text = tostring(def), Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = T.TextMuted,
		TextXAlignment = Enum.TextXAlignment.Right, Parent = c,
	})
	local bar = N("Frame", { Position = U2(0, 10, 0, 33), Size = U2(1, -20, 0, 4), BackgroundColor3 = T.ToggleOff, BorderSizePixel = 0, Parent = c })
	R(bar, 2)
	local fill = N("Frame", { Size = U2((def - min) / (max - min), 0, 1, 0), BackgroundColor3 = T.Accent, BorderSizePixel = 0, Parent = bar })
	R(fill, 2)
	local hit = N("TextButton", { Position = U2(0, 0, 0, 24), Size = U2(1, 0, 0, 20), BackgroundTransparency = 1, Text = "", Parent = c })
	local sliding = false
	local function upd(x)
		local a = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
		local v = math.floor(min + (max - min) * a + 0.5)
		Flags[flag] = v
		val.Text = tostring(v)
		fill.Size = U2(a, 0, 1, 0)
		if cb then pcall(cb, v) end
	end
	hit.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
			sliding = true
			upd(i.Position.X)
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if sliding and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then upd(i.Position.X) end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
	end)
end

local PRESETS = {
	C(246, 92, 82), C(255, 165, 155), C(255, 200, 80), C(110, 220, 120),
	C(80, 200, 255), C(120, 120, 255), C(210, 110, 255), C(255, 255, 255),
}
local function ColorPick(tab, name, flag, def, cb)
	Flags[flag] = def
	local c = Card(tab, name)
	local sw = N("TextButton", {
		AnchorPoint = Vector2.new(1, 0), Position = U2(1, -8, 0, 6), Size = U2(0, 32, 0, 18), Text = "",
		BackgroundColor3 = def, BorderSizePixel = 0, AutoButtonColor = false, Parent = c,
	})
	R(sw, 5)
	N("UIStroke", { Color = T.BorderActive, Thickness = 1, Parent = sw })
	local idx = 1
	sw.MouseButton1Click:Connect(function()
		idx = idx % #PRESETS + 1
		Flags[flag] = PRESETS[idx]
		sw.BackgroundColor3 = PRESETS[idx]
		if cb then pcall(cb, PRESETS[idx]) end
	end)
end

-- Выбор из списка (кнопка листает варианты)
local function Cycle(tab, name, flag, list, cb)
	local idx = 1
	Flags[flag] = list[1]
	local c, lbl = Card(tab, name .. ": " .. list[1])
	local b = N("TextButton", { Size = U2(1, 0, 0, 30), BackgroundTransparency = 1, Text = "", Parent = c })
	b.MouseButton1Click:Connect(function()
		idx = idx % #list + 1
		Flags[flag] = list[idx]
		lbl.Text = name .. ": " .. list[idx]
		if cb then pcall(cb, list[idx]) end
	end)
end

SI:GetPropertyChangedSignal("Text"):Connect(function()
	local q = SI.Text:lower()
	for _, it in ipairs(Items) do it.card.Visible = q == "" or it.name:find(q, 1, true) ~= nil end
end)

-- ============================================================
-- 3. СИСТЕМА ВИЗУАЛОВ (общий цикл, авто-восстановление после респавна)
-- ============================================================
local Debris = game:GetService("Debris")
local Cam = WS.CurrentCamera
WS:GetPropertyChangedSignal("CurrentCamera"):Connect(function() Cam = WS.CurrentCamera end)

local function getChar() return LP.Character end
local function getHrp() local c = LP.Character return c and c:FindFirstChild("HumanoidRootPart") end
local function getHead() local c = LP.Character return c and c:FindFirstChild("Head") end
local function getHum() local c = LP.Character return c and c:FindFirstChildOfClass("Humanoid") end

-- Папка для всех наших объектов в мире (чистится одним вызовом)
local World = WS:FindFirstChild("NH_World") or N("Folder", { Name = "NH_World", Parent = WS })

-- Циклы: name -> function(dt)
local Loops = {}
RNS.RenderStepped:Connect(function(dt)
	for name, fn in pairs(Loops) do
		local ok, err = pcall(fn, dt)
		if not ok then Loops[name] = nil warn("[NH] loop " .. name .. ": " .. tostring(err)) end
	end
end)

-- Функции, которые надо переприменить после респавна
local Respawn = {}
LP.CharacterAdded:Connect(function()
	task.wait(0.8)
	for flag, fn in pairs(Respawn) do
		if Flags[flag] then pcall(fn) end
	end
end)

local function rainbow(off) return Color3.fromHSV((tick() * 0.25 + (off or 0)) % 1, 0.75, 1) end

-- Универсальный "эффект с автоочисткой"
local function makePart(props)
	local p = N("Part", {
		Anchored = true, CanCollide = false, CanQuery = false, CanTouch = false, Massless = true,
		Material = Enum.Material.Neon, Size = Vector3.new(1, 1, 1), Parent = World,
	})
	for k, v in pairs(props or {}) do p[k] = v end
	return p
end

-- ============================================================
-- 4. ВКЛАДКИ
-- ============================================================
local tWorld   = addTab("World",   IC.Visuals, 1, true)
local tPlayer  = addTab("Player",  IC.User,    2)
local tEffects = addTab("Effects", IC.Combat,  3)
local tScreen  = addTab("Screen",  IC.Chart,   4)
local tMisc    = addTab("Misc",    IC.Misc,    5)

-- ======================= WORLD =======================
Header(tWorld, "Skybox")
-- Проверенные наборы скайбоксов (стандартные ассеты Roblox)
local SKY = {
	Night  = { "rbxassetid://159454299", "rbxassetid://159454296", "rbxassetid://159454293", "rbxassetid://159454286", "rbxassetid://159454300", "rbxassetid://159454288" },
	Purple = { "rbxassetid://600830446", "rbxassetid://600831635", "rbxassetid://600832720", "rbxassetid://600833862", "rbxassetid://600835177", "rbxassetid://600836000" },
	Pink   = { "rbxassetid://271042310", "rbxassetid://271042516", "rbxassetid://271077243", "rbxassetid://271042556", "rbxassetid://271042310", "rbxassetid://271077958" },
	Space  = { "rbxassetid://149397684", "rbxassetid://149397692", "rbxassetid://149397697", "rbxassetid://149397702", "rbxassetid://149397710", "rbxassetid://149397718" },
}
local skyNames = { "Night", "Purple", "Pink", "Space" }
local origSkies = {}
local customSky
local function applySky()
	if customSky then customSky:Destroy() customSky = nil end
	for _, s in ipairs(origSkies) do if s.Parent then s.Parent = LG end end
	if not Flags.sky then return end
	-- прячем оригинальные небеса, иначе они перекрывают кастомное
	origSkies = {}
	for _, s in ipairs(LG:GetChildren()) do
		if s:IsA("Sky") and s.Name ~= "NH_Sky" then
			origSkies[#origSkies + 1] = s
			s.Parent = nil
		end
	end
	local s = SKY[Flags.skyName] or SKY.Night
	customSky = N("Sky", {
		Name = "NH_Sky", SkyboxBk = s[1], SkyboxDn = s[2], SkyboxFt = s[3], SkyboxLf = s[4], SkyboxRt = s[5], SkyboxUp = s[6],
		StarCount = 3000, CelestialBodiesShown = false, Parent = LG,
	})
end
Toggle(tWorld, "Custom Skybox", "sky", applySky)
Cycle(tWorld, "Skybox", "skyName", skyNames, applySky)

Header(tWorld, "Fog")
local fogBackup = { s = LG.FogStart, e = LG.FogEnd, c = LG.FogColor }
local atmo = LG:FindFirstChildOfClass("Atmosphere")
local atmoBackup = atmo and { d = atmo.Density, o = atmo.Offset } or nil
local function applyFog()
	if Flags.fog then
		LG.FogColor, LG.FogStart, LG.FogEnd = Flags.fogCol, 0, Flags.fogEnd
		if atmo then atmo.Density, atmo.Offset = 0, 0 end -- Atmosphere перебивает туман
	else
		LG.FogStart, LG.FogEnd, LG.FogColor = fogBackup.s, fogBackup.e, fogBackup.c
		if atmo and atmoBackup then atmo.Density, atmo.Offset = atmoBackup.d, atmoBackup.o end
	end
end
Toggle(tWorld, "Custom Fog", "fog", applyFog)
Slider(tWorld, "Fog Distance", "fogEnd", 20, 1000, 200, applyFog)
ColorPick(tWorld, "Fog Color", "fogCol", C(246, 92, 82), applyFog)

Header(tWorld, "Lighting")
local lt = { B = LG.Brightness, A = LG.Ambient, O = LG.OutdoorAmbient, T = LG.ClockTime, E = LG.ExposureCompensation }
Toggle(tWorld, "Fullbright", "fb", function(v)
	if v then
		Loops.fb = function()
			LG.Brightness, LG.Ambient, LG.OutdoorAmbient = 2, C(200, 200, 200), C(200, 200, 200)
		end
	else
		Loops.fb = nil
		LG.Brightness, LG.Ambient, LG.OutdoorAmbient = lt.B, lt.A, lt.O
	end
end)
Toggle(tWorld, "Custom Time", "timeOn", function(v)
	if v then Loops.time = function() LG.ClockTime = Flags.time end
	else Loops.time = nil LG.ClockTime = lt.T end
end)
Slider(tWorld, "Time of Day", "time", 0, 24, math.floor(LG.ClockTime))
Toggle(tWorld, "Time Cycle", "timeCycle", function(v)
	if v then Loops.cycle = function(dt) LG.ClockTime = (LG.ClockTime + dt * 0.4) % 24 end
	else Loops.cycle = nil end
end)
Toggle(tWorld, "No Shadows", "noshadow", function(v) LG.GlobalShadows = not v end)
Toggle(tWorld, "Ambient Color", "ambOn", function(v)
	if v then Loops.amb = function() LG.Ambient = Flags.ambCol LG.OutdoorAmbient = Flags.ambCol end
	else Loops.amb = nil LG.Ambient, LG.OutdoorAmbient = lt.A, lt.O end
end)
ColorPick(tWorld, "Ambient", "ambCol", C(246, 92, 82))
Toggle(tWorld, "Rainbow World", "rbw", function(v)
	if v then Loops.rbw = function() local c = rainbow() LG.Ambient = c LG.OutdoorAmbient = c end
	else Loops.rbw = nil LG.Ambient, LG.OutdoorAmbient = lt.A, lt.O end
end)

Header(tWorld, "World")
Toggle(tWorld, "Remove Textures", "notex", function(v)
	for _, d in ipairs(WS:GetDescendants()) do
		if d:IsA("Texture") or d:IsA("Decal") then
			if v then d:SetAttribute("NHT", d.Transparency) d.Transparency = 1
			else d.Transparency = d:GetAttribute("NHT") or 0 end
		end
	end
end)
Toggle(tWorld, "Smooth Plastic", "plastic", function(v)
	for _, d in ipairs(WS:GetDescendants()) do
		if d:IsA("BasePart") and not d:IsDescendantOf(LP.Character or World) then
			if v then d:SetAttribute("NHM", d.Material.Name) d.Material = Enum.Material.SmoothPlastic
			else local m = d:GetAttribute("NHM") if m then d.Material = Enum.Material[m] end end
		end
	end
end)

-- ======================= PLAYER =======================
Header(tPlayer, "China Hat")
-- Шляпа из клиньев (WedgePart) на WeldConstraint к голове: не отстаёт, не дёргается. 5 стилей.
local HAT_SEG, HAT_THICK = 24, 0.05
local HAT_STYLES = { "Cone", "Dome", "Top Hat", "Halo", "Horns" }

local function makeTriangle(a, b, c)
	local ab, ac, bc = b - a, c - a, c - b
	local abd, acd, bcd = ab:Dot(ab), ac:Dot(ac), bc:Dot(bc)
	if abd > acd and abd > bcd then c, a = a, c
	elseif acd > bcd and acd > abd then a, b = b, a end
	ab, ac, bc = b - a, c - a, c - b
	local right = ac:Cross(ab).Unit
	local up = bc:Cross(right).Unit
	local back = bc.Unit
	local height = math.abs(ab:Dot(up))
	local w1 = I("WedgePart")
	w1.Size = Vector3.new(HAT_THICK, height, math.abs(ab:Dot(back)))
	w1.CFrame = CFrame.fromMatrix((a + b) / 2, right, up, back)
	local w2 = I("WedgePart")
	w2.Size = Vector3.new(HAT_THICK, height, math.abs(ac:Dot(back)))
	w2.CFrame = CFrame.fromMatrix((a + c) / 2, -right, up, -back)
	return w1, w2
end

local hat -- { folder, parts, head, light }
local function destroyHat()
	Loops.hat = nil
	if hat then
		if hat.light then hat.light:Destroy() end
		hat.folder:Destroy()
		hat = nil
	end
end

local function hatAdd(folder, parts, head, part)
	part.Material = Enum.Material.SmoothPlastic
	part.CastShadow, part.CanCollide, part.CanQuery, part.CanTouch, part.Massless = false, false, false, false, true
	part.Transparency = 1
	part.Color = Flags.hatCol
	part.Parent = folder
	local w = I("WeldConstraint")
	w.Part0, w.Part1, w.Parent = head, part, part
	parts[#parts + 1] = part
end

local function buildHat()
	destroyHat()
	local ch = getChar()
	local head = ch and ch:WaitForChild("Head", 5)
	if not head then return end

	local folder = N("Folder", { Name = "NH_ChinaHat", Parent = ch })
	local parts = {}
	local baseY = head.Size.Y / 2
	local R0, H, GAP = Flags.hatRadius / 10, Flags.hatHeight / 10, 0.3
	local style = Flags.hatStyle

	if style == "Dome" then
		local d = R0 * 2
		local p = I("Part")
		p.Shape, p.Size = Enum.PartType.Ball, Vector3.new(d, d, d)
		p.CFrame = head.CFrame * CFrame.new(0, baseY + d * 0.3, 0)
		hatAdd(folder, parts, head, p)

	elseif style == "Horns" then
		local length = 0.8 + H * 0.9
		local baseR = math.max(0.06, R0 * 0.1)
		local stations, sides = 8, 6
		local hcf = head.CFrame
		for _, side in ipairs({ -1, 1 }) do
			local base = Vector3.new(side * head.Size.X * 0.28, baseY - 0.08 + GAP, -0.05)
			local function point(t)
				return base + Vector3.new(
					side * (0.35 * t + 0.25 * t * t) * length,
					(0.95 * t - 0.15 * t * t * t) * length,
					0.3 * t * t * length)
			end
			local rings = {}
			for i = 0, stations - 1 do
				local t = i / stations
				local center = point(t)
				local tan = (point(math.min(t + 0.01, 1)) - point(math.max(t - 0.01, 0))).Unit
				local nrm = tan:Cross(Vector3.zAxis)
				if nrm.Magnitude < 0.01 then nrm = tan:Cross(Vector3.xAxis) end
				nrm = nrm.Unit
				local bin = tan:Cross(nrm).Unit
				local rad = baseR * (1 - t * 0.92)
				local ring = {}
				for j = 0, sides - 1 do
					local ang = j / sides * math.pi * 2
					ring[j + 1] = (hcf * CFrame.new(center + (nrm * math.cos(ang) + bin * math.sin(ang)) * rad)).Position
				end
				rings[i + 1] = ring
			end
			local tip = (hcf * CFrame.new(point(1))).Position
			local function tri(a, b, c)
				local w1, w2 = makeTriangle(a, b, c)
				hatAdd(folder, parts, head, w1)
				hatAdd(folder, parts, head, w2)
			end
			for i = 1, #rings - 1 do
				for j = 1, sides do
					local k = j % sides + 1
					tri(rings[i][j], rings[i][k], rings[i + 1][j])
					tri(rings[i][k], rings[i + 1][k], rings[i + 1][j])
				end
			end
			local last = rings[#rings]
			for j = 1, sides do tri(last[j], last[j % sides + 1], tip) end
		end

	elseif style == "Halo" then
		local hcf = head.CFrame * CFrame.new(0, baseY + GAP + 0.35, 0) * CFrame.Angles(math.rad(8), 0, 0)
		for _, spec in ipairs({ { R0 * 0.6, 0.1 }, { R0 * 0.44, 0.04 } }) do
			local rad, th = spec[1], spec[2]
			local segs = 36
			local len = 2 * math.pi * rad / segs * 1.08
			for i = 1, segs do
				local ang = (i - 1) / segs * math.pi * 2
				local p = I("Part")
				p.Size = Vector3.new(th, th, len)
				p.CFrame = hcf * CFrame.Angles(0, ang, 0) * CFrame.new(rad, 0, 0)
				hatAdd(folder, parts, head, p)
			end
		end

	elseif style == "Top Hat" then
		local top = I("Part")
		top.Shape, top.Size = Enum.PartType.Cylinder, Vector3.new(H, R0 * 1.3, R0 * 1.3)
		top.CFrame = head.CFrame * CFrame.new(0, baseY + H / 2, 0) * CFrame.Angles(0, 0, math.pi / 2)
		hatAdd(folder, parts, head, top)
		local brim = I("Part")
		brim.Shape, brim.Size = Enum.PartType.Cylinder, Vector3.new(0.08, R0 * 2.6, R0 * 2.6)
		brim.CFrame = head.CFrame * CFrame.new(0, baseY + 0.04, 0) * CFrame.Angles(0, 0, math.pi / 2)
		hatAdd(folder, parts, head, brim)

	else -- Cone: полая стенка из треугольников
		local hcf = head.CFrame
		local rimY = baseY + GAP
		local tip = (hcf * CFrame.new(0, rimY + H, 0)).Position
		for i = 0, HAT_SEG - 1 do
			local a1 = i / HAT_SEG * math.pi * 2
			local a2 = (i + 1) / HAT_SEG * math.pi * 2
			local p1 = (hcf * CFrame.new(math.cos(a1) * R0, rimY, math.sin(a1) * R0)).Position
			local p2 = (hcf * CFrame.new(math.cos(a2) * R0, rimY, math.sin(a2) * R0)).Position
			local w1, w2 = makeTriangle(tip, p1, p2)
			hatAdd(folder, parts, head, w1)
			hatAdd(folder, parts, head, w2)
		end
	end

	-- свет для свечения
	local att = N("Attachment", { Name = "NH_HatLight", Position = Vector3.new(0, baseY + GAP + H / 2, 0), Parent = head })
	local light = N("PointLight", { Shadows = false, Enabled = false, Parent = att })
	hat = { folder = folder, parts = parts, head = head, light = att, pl = light }

	-- покраска/прозрачность каждый кадр (радуга, свечение, скрытие в первом лице)
	Loops.hat = function()
		if not hat or not hat.folder.Parent then return end
		local first = (Cam.CFrame.Position - head.Position).Magnitude < 1.5
		local col = Flags.hatRainbow and rainbow() or Flags.hatCol
		local glow = Flags.hatGlow
		local tr = first and 1 or Flags.hatTr / 100
		for _, p in ipairs(parts) do
			p.Color = col
			p.Transparency = tr
			p.Material = glow and Enum.Material.Neon or Enum.Material.SmoothPlastic
		end
		hat.pl.Enabled = glow and not first
		hat.pl.Color = col
		hat.pl.Brightness = Flags.hatGlowPow
		hat.pl.Range = 8 + Flags.hatGlowPow * 2
	end
end

local function rebuildHat() if Flags.hat then buildHat() end end
Toggle(tPlayer, "China Hat", "hat", function(v) if v then buildHat() else destroyHat() end end)
Respawn.hat = buildHat
Cycle(tPlayer, "Hat Style", "hatStyle", HAT_STYLES, rebuildHat)
Toggle(tPlayer, "Hat Rainbow", "hatRainbow")
Toggle(tPlayer, "Hat Glow", "hatGlow")
ColorPick(tPlayer, "Hat Color", "hatCol", C(255, 90, 90))
Slider(tPlayer, "Hat Radius", "hatRadius", 8, 30, 14, rebuildHat)
Slider(tPlayer, "Hat Height", "hatHeight", 4, 30, 9, rebuildHat)
Slider(tPlayer, "Hat Opacity", "hatTr", 0, 90, 35)
Slider(tPlayer, "Glow Power", "hatGlowPow", 1, 5, 2)

Header(tPlayer, "Cosmetics")
local function killHalo()
	local ch = getChar()
	local o = ch and ch:FindFirstChild("NH_Halo")
	if o then o:Destroy() end
	Loops.halo = nil
end
local function buildHalo()
	killHalo()
	local ch = getChar()
	local head = ch and ch:WaitForChild("Head", 5)
	if not head then return end
	local folder = N("Folder", { Name = "NH_Halo", Parent = ch })
	local hcf = head.CFrame * CFrame.new(0, head.Size.Y / 2 + 0.75, 0) * CFrame.Angles(math.rad(8), 0, 0)
	local parts = {}
	for _, spec in ipairs({ { 0.9, 0.1 }, { 0.65, 0.04 } }) do
		local rad, th = spec[1], spec[2]
		local segs = 36
		local len = 2 * math.pi * rad / segs * 1.08
		for i = 1, segs do
			local ang = (i - 1) / segs * math.pi * 2
			local p = I("Part")
			p.Size = Vector3.new(th, th, len)
			p.CFrame = hcf * CFrame.Angles(0, ang, 0) * CFrame.new(rad, 0, 0)
			p.Material, p.Color = Enum.Material.Neon, C(255, 225, 120)
			p.CastShadow, p.CanCollide, p.CanQuery, p.CanTouch, p.Massless = false, false, false, false, true
			p.Parent = folder
			local w = I("WeldConstraint")
			w.Part0, w.Part1, w.Parent = head, p, p
			parts[#parts + 1] = p
		end
	end
	Loops.halo = function()
		local first = (Cam.CFrame.Position - head.Position).Magnitude < 1.5
		for _, p in ipairs(parts) do p.Transparency = first and 1 or 0.1 end
	end
end
Toggle(tPlayer, "Halo", "halo", function(v) if v then buildHalo() else killHalo() end end)
Respawn.halo = buildHalo

local function eachPart(fn)
	local c = getChar()
	if not c then return end
	for _, p in ipairs(c:GetDescendants()) do
		if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then fn(p) end
	end
end
Toggle(tPlayer, "Neon Body", "neon", function(v)
	eachPart(function(p)
		if v then
			if not p:GetAttribute("NHMat") then p:SetAttribute("NHMat", p.Material.Name) end
			p.Material = Enum.Material.Neon
		else
			local m = p:GetAttribute("NHMat")
			if m then p.Material = Enum.Material[m] p:SetAttribute("NHMat", nil) end
		end
	end)
end)
Respawn.neon = function() eachPart(function(p) p.Material = Enum.Material.Neon end) end
Toggle(tPlayer, "Ghost Body", "ghost", function(v)
	eachPart(function(p)
		if v then
			if p:GetAttribute("NHTr") == nil then p:SetAttribute("NHTr", p.Transparency) end
			p.Transparency = 0.6
		else
			p.Transparency = p:GetAttribute("NHTr") or 0
			p:SetAttribute("NHTr", nil)
		end
	end)
end)
Respawn.ghost = function() eachPart(function(p) p.Transparency = 0.6 end) end
Toggle(tPlayer, "Body Color", "bodyCol", function(v)
	if v then
		Loops.bodyCol = function()
			local c = getChar()
			if not c then return end
			for _, p in ipairs(c:GetDescendants()) do
				if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Color = Flags.bodyColor end
			end
		end
	else Loops.bodyCol = nil end
end)
ColorPick(tPlayer, "Body", "bodyColor", C(246, 92, 82))
Toggle(tPlayer, "Rainbow Body", "bodyRbw", function(v)
	if v then
		Loops.bodyRbw = function()
			local c = getChar()
			if not c then return end
			local col = rainbow()
			for _, p in ipairs(c:GetDescendants()) do
				if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Color = col end
			end
		end
	else Loops.bodyRbw = nil end
end)
Toggle(tPlayer, "Selection Glow", "glow", function(v)
	local c = getChar()
	local old = c and c:FindFirstChild("NH_Glow")
	if old then old:Destroy() end
	if not v or not c then return end
	N("Highlight", {
		Name = "NH_Glow", FillColor = T.Accent, OutlineColor = T.AccentSoft, FillTransparency = 0.7,
		OutlineTransparency = 0, DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Parent = c,
	})
end)
Respawn.glow = function() if Setters.glow then Setters.glow(false) Setters.glow(true) end end
Toggle(tPlayer, "Big Head", "bighead", function(v)
	local h = getHead()
	if not h then return end
	if v then
		if not h:GetAttribute("NHS") then h:SetAttribute("NHS", h.Size.X) end
		h.Size = h.Size * 1.6
	else
		local s = h:GetAttribute("NHS")
		if s then h.Size = Vector3.new(s, s, s) h:SetAttribute("NHS", nil) end
	end
end)

Header(tPlayer, "Accessories")
-- Общий движок аксов: детали привариваются к части тела (WeldConstraint), скрываются в первом лице
local Acc = {} -- name -> { folder, parts, anchorPart, update }
local function accKill(name)
	local a = Acc[name]
	if a then
		Loops["acc_" .. name] = nil
		if a.folder then a.folder:Destroy() end
		Acc[name] = nil
	end
end
local function accPart(folder, anchor, props, cf)
	local p = I("Part")
	p.Material, p.Color = Enum.Material.Neon, Flags.accCol
	p.CastShadow, p.CanCollide, p.CanQuery, p.CanTouch, p.Massless = false, false, false, false, true
	p.Transparency = 0.15
	for k, v in pairs(props) do p[k] = v end
	p.CFrame = cf
	p.Parent = folder
	local w = I("WeldConstraint")
	w.Part0, w.Part1, w.Parent = anchor, p, p
	return p
end
-- Цвет/скрытие для всех аксов (один раз за кадр)
local function accTick(name, parts, anchor)
	Loops["acc_" .. name] = function()
		local first = (Cam.CFrame.Position - anchor.Position).Magnitude < 1.8
		local col = Flags.accRbw and rainbow() or Flags.accCol
		for _, p in ipairs(parts) do
			p.Color = col
			p.Transparency = first and 1 or 0.15
		end
	end
end
local function charPart(n) local c = getChar() return c and (c:FindFirstChild(n) or c:WaitForChild(n, 3)) end
local function torso()
	local c = getChar()
	return c and (c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso"))
end

-- ---------- ВЫБОР СТИЛЯ КРЫЛЬЕВ ----------
local WING_STYLES = { "Angel", "Demon", "Dragon", "Butterfly" }
-- Контур крыла: набор (лучей) от плеча: { угол, длина }
local WING_SHAPES = {
	Angel     = { { 20, 3.6 }, { 38, 4.2 }, { 56, 4.4 }, { 74, 4.0 }, { 92, 3.4 }, { 110, 2.6 } },
	Demon     = { { 10, 3.0 }, { 32, 4.6 }, { 55, 5.2 }, { 80, 4.4 }, { 105, 3.2 } },
	Dragon    = { { 5, 4.8 }, { 28, 5.6 }, { 52, 5.0 }, { 76, 4.2 }, { 100, 3.4 }, { 124, 2.4 } },
	Butterfly = { { 25, 3.4 }, { 50, 3.8 }, { 75, 3.0 }, { 105, 2.4 } },
}
local function buildWings()
	accKill("wings")
	local ch, tor = getChar(), torso()
	if not ch or not tor then return end
	local folder = N("Folder", { Name = "NH_Wings", Parent = ch })
	local parts, sides = {}, {}
	local shape = WING_SHAPES[Flags.wingStyle] or WING_SHAPES.Angel
	local sc = Flags.wingScale / 10
	for _, side in ipairs({ -1, 1 }) do
		-- плечо: точка крепления на спине
		local root = Vector3.new(side * 0.35, 0.5, 0.55)
		for _, ray in ipairs(shape) do
			local ang = math.rad(ray[1])
			local len = ray[2] * sc
			-- направление луча: наружу и вверх/вниз, ложится в плоскость за спиной
			local dir = Vector3.new(side * math.sin(ang), math.cos(ang) * 0.9, 0.35).Unit
			local mid = root + dir * (len / 2)
			local p = accPart(folder, tor, { Size = Vector3.new(0.12, 0.12, len) },
				tor.CFrame * CFrame.lookAt(mid, mid + dir) )
			parts[#parts + 1] = p
			sides[#sides + 1] = { part = p, side = side, ang = ang, len = len, root = root }
		end
	end
	Acc.wings = { folder = folder, parts = parts }
	-- взмах: качаем крылья вокруг оси спины
	Loops.acc_wings = function()
		local t = tor
		if not t.Parent then return end
		local first = (Cam.CFrame.Position - t.Position).Magnitude < 1.8
		local col = Flags.accRbw and rainbow() or Flags.accCol
		local flap = Flags.wingFlap and math.sin(tick() * 3) * 0.28 or 0
		for _, d in ipairs(sides) do
			local dir = Vector3.new(d.side * math.sin(d.ang), math.cos(d.ang) * 0.9, 0.35).Unit
			-- поворот направления вокруг оси Y (взмах наружу-внутрь)
			local rot = CFrame.Angles(0, d.side * flap, 0)
			local nd = rot:VectorToWorldSpace(dir)
			local mid = d.root + nd * (d.len / 2)
			d.part.CFrame = t.CFrame * CFrame.lookAt(mid, mid + nd)
			d.part.Color = col
			d.part.Transparency = first and 1 or 0.15
		end
	end
end
Toggle(tPlayer, "Wings", "wings", function(v) if v then buildWings() else accKill("wings") end end)
Respawn.wings = buildWings
Cycle(tPlayer, "Wing Style", "wingStyle", WING_STYLES, function() if Flags.wings then buildWings() end end)
Toggle(tPlayer, "Wing Flap", "wingFlap")
Slider(tPlayer, "Wing Size", "wingScale", 6, 20, 10, function() if Flags.wings then buildWings() end end)

-- ---------- ПЛАЩ ----------
local function buildCape()
	accKill("cape")
	local ch, tor = getChar(), torso()
	if not ch or not tor then return end
	local folder = N("Folder", { Name = "NH_Cape", Parent = ch })
	local parts = {}
	local segs = 6
	local segH = 0.55
	local panels = {}
	for i = 1, segs do
		local p = accPart(folder, tor, { Size = Vector3.new(1.9 - i * 0.05, segH, 0.08), Material = Enum.Material.SmoothPlastic },
			tor.CFrame * CFrame.new(0, 0.9 - (i - 1) * segH, 0.6))
		parts[i] = p
		panels[i] = p
	end
	Acc.cape = { folder = folder, parts = parts }
	Loops.acc_cape = function()
		if not tor.Parent then return end
		local first = (Cam.CFrame.Position - tor.Position).Magnitude < 1.8
		local col = Flags.accRbw and rainbow() or Flags.accCol
		local h = getHum()
		local spd = h and h.MoveDirection.Magnitude > 0 and 1 or 0
		for i, p in ipairs(panels) do
			-- чем ниже сегмент, тем сильнее отклоняется назад при ходьбе
			local swing = (math.sin(tick() * 5 + i * 0.4) * 0.07 + 0.12) * i * (0.4 + spd)
			p.CFrame = tor.CFrame * CFrame.new(0, 0.9 - (i - 1) * segH, 0.6 + swing * 0.6)
				* CFrame.Angles(swing * 0.6, 0, 0)
			p.Color = col
			p.Transparency = first and 1 or 0.05
		end
	end
end
Toggle(tPlayer, "Cape", "cape", function(v) if v then buildCape() else accKill("cape") end end)
Respawn.cape = buildCape

-- ---------- КОРОНА ----------
local function buildCrown()
	accKill("crown")
	local ch = getChar()
	local head = ch and ch:WaitForChild("Head", 5)
	if not head then return end
	local folder = N("Folder", { Name = "NH_Crown", Parent = ch })
	local parts = {}
	local base = head.Size.Y / 2 + 0.15
	-- обруч
	local n = 12
	for i = 1, n do
		local a = i / n * math.pi * 2
		local p = accPart(folder, head, { Size = Vector3.new(0.18, 0.28, 0.4), Material = Enum.Material.Neon },
			head.CFrame * CFrame.new(math.cos(a) * 0.82, base, math.sin(a) * 0.82) * CFrame.Angles(0, -a + math.pi / 2, 0))
		parts[#parts + 1] = p
	end
	-- зубцы
	for i = 1, 6 do
		local a = i / 6 * math.pi * 2
		local p = accPart(folder, head, { Size = Vector3.new(0.18, 0.5, 0.18) },
			head.CFrame * CFrame.new(math.cos(a) * 0.82, base + 0.35, math.sin(a) * 0.82))
		parts[#parts + 1] = p
	end
	Acc.crown = { folder = folder, parts = parts }
	accTick("crown", parts, head)
end
Toggle(tPlayer, "Crown", "crown", function(v) if v then buildCrown() else accKill("crown") end end)
Respawn.crown = buildCrown

-- ---------- УШИ (кошачьи) ----------
local function buildEars()
	accKill("ears")
	local ch = getChar()
	local head = ch and ch:WaitForChild("Head", 5)
	if not head then return end
	local folder = N("Folder", { Name = "NH_Ears", Parent = ch })
	local parts = {}
	for _, side in ipairs({ -1, 1 }) do
		local p = accPart(folder, head, { Size = Vector3.new(0.45, 0.7, 0.18), Material = Enum.Material.SmoothPlastic },
			head.CFrame * CFrame.new(side * 0.5, head.Size.Y / 2 + 0.3, 0) * CFrame.Angles(0, 0, math.rad(-side * 14)))
		parts[#parts + 1] = p
	end
	Acc.ears = { folder = folder, parts = parts }
	accTick("ears", parts, head)
end
Toggle(tPlayer, "Cat Ears", "ears", function(v) if v then buildEars() else accKill("ears") end end)
Respawn.ears = buildEars

-- ---------- ОЧКИ ----------
local function buildGlasses()
	accKill("glasses")
	local ch = getChar()
	local head = ch and ch:WaitForChild("Head", 5)
	if not head then return end
	local folder = N("Folder", { Name = "NH_Glasses", Parent = ch })
	local parts = {}
	for _, side in ipairs({ -1, 1 }) do
		parts[#parts + 1] = accPart(folder, head, { Size = Vector3.new(0.5, 0.32, 0.07), Transparency = 0.25 },
			head.CFrame * CFrame.new(side * 0.3, 0.1, -head.Size.Z / 2 - 0.04))
	end
	parts[#parts + 1] = accPart(folder, head, { Size = Vector3.new(0.2, 0.07, 0.07) },
		head.CFrame * CFrame.new(0, 0.12, -head.Size.Z / 2 - 0.04))
	Acc.glasses = { folder = folder, parts = parts }
	accTick("glasses", parts, head)
end
Toggle(tPlayer, "Glasses", "glasses", function(v) if v then buildGlasses() else accKill("glasses") end end)
Respawn.glasses = buildGlasses

-- ---------- ХВОСТ ----------
local function buildTail()
	accKill("tail")
	local ch, tor = getChar(), torso()
	if not ch or not tor then return end
	local folder = N("Folder", { Name = "NH_Tail", Parent = ch })
	local segs = {}
	for i = 1, 7 do
		segs[i] = accPart(folder, tor, { Size = Vector3.new(0.3 - i * 0.025, 0.3 - i * 0.025, 0.5), Material = Enum.Material.SmoothPlastic },
			tor.CFrame * CFrame.new(0, -0.7, 0.7 + i * 0.4))
	end
	Acc.tail = { folder = folder, parts = segs }
	Loops.acc_tail = function()
		if not tor.Parent then return end
		local first = (Cam.CFrame.Position - tor.Position).Magnitude < 1.8
		local col = Flags.accRbw and rainbow() or Flags.accCol
		for i, p in ipairs(segs) do
			local wag = math.sin(tick() * 3 + i * 0.5) * 0.35 * (i / 7)
			p.CFrame = tor.CFrame * CFrame.new(wag, -0.7 + i * 0.12, 0.7 + i * 0.35) * CFrame.Angles(math.rad(-12), wag * 0.4, 0)
			p.Color = col
			p.Transparency = first and 1 or 0.05
		end
	end
end
Toggle(tPlayer, "Tail", "tail", function(v) if v then buildTail() else accKill("tail") end end)
Respawn.tail = buildTail

-- ---------- АУРА-КОЛЬЦА ----------
Toggle(tPlayer, "Aura Rings", "aura", function(v)
	accKill("aura")
	if not v then return end
	local ch = getChar()
	local root = getHrp()
	if not ch or not root then return end
	local folder = N("Folder", { Name = "NH_Aura", Parent = ch })
	local rings = {}
	for r = 1, 3 do
		local parts = {}
		local n = 24
		for i = 1, n do
			local a = i / n * math.pi * 2
			parts[i] = accPart(folder, root, { Size = Vector3.new(0.14, 0.14, 0.3), Transparency = 0.2 },
				root.CFrame * CFrame.new(math.cos(a) * 2.5, 0, math.sin(a) * 2.5))
		end
		rings[r] = parts
	end
	Acc.aura = { folder = folder }
	Loops.acc_aura = function()
		if not root.Parent then return end
		local t = tick()
		local col = Flags.accRbw and rainbow() or Flags.accCol
		for r, parts in ipairs(rings) do
			local y = (r - 2) * 1.6 + math.sin(t * 2 + r) * 0.25
			local rot = t * (r % 2 == 0 and 1.5 or -1.5)
			for i, p in ipairs(parts) do
				local a = i / #parts * math.pi * 2 + rot
				p.CFrame = root.CFrame * CFrame.new(math.cos(a) * 2.5, y, math.sin(a) * 2.5) * CFrame.Angles(0, -a, 0)
				p.Color = col
			end
		end
	end
end)
Respawn.aura = function() if Setters.aura then Setters.aura(false) Setters.aura(true) end end

ColorPick(tPlayer, "Accessory Color", "accCol", C(246, 92, 82))
Toggle(tPlayer, "Accessory Rainbow", "accRbw")

Header(tPlayer, "Targets")
Toggle(tPlayer, "Player ESP", "esp", function(v)
	for _, p in ipairs(PL:GetPlayers()) do
		if p ~= LP and p.Character then
			local old = p.Character:FindFirstChild("NH_ESP")
			if old then old:Destroy() end
			if v then
				N("Highlight", {
					Name = "NH_ESP", FillColor = T.Accent, OutlineColor = C(255, 255, 255), FillTransparency = 0.6,
					DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Parent = p.Character,
				})
			end
		end
	end
end)
local function espAdd(p)
	p.CharacterAdded:Connect(function(ch)
		task.wait(0.5)
		if Flags.esp then
			N("Highlight", {
				Name = "NH_ESP", FillColor = T.Accent, OutlineColor = C(255, 255, 255), FillTransparency = 0.6,
				DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Parent = ch,
			})
		end
	end)
end
for _, p in ipairs(PL:GetPlayers()) do if p ~= LP then espAdd(p) end end
PL.PlayerAdded:Connect(espAdd)

Toggle(tPlayer, "Name Tags", "tags", function(v)
	for _, p in ipairs(PL:GetPlayers()) do
		local h = p ~= LP and p.Character and p.Character:FindFirstChild("Head")
		if h then
			local old = h:FindFirstChild("NH_Tag")
			if old then old:Destroy() end
			if v then
				local bb = N("BillboardGui", {
					Name = "NH_Tag", Size = U2(0, 120, 0, 22), StudsOffset = Vector3.new(0, 2.4, 0), AlwaysOnTop = true, Parent = h,
				})
				N("TextLabel", {
					Size = U2(1, 0, 1, 0), BackgroundTransparency = 1, Text = p.DisplayName, Font = Enum.Font.GothamBold,
					TextSize = 13, TextColor3 = T.Accent, TextStrokeTransparency = 0.4, Parent = bb,
				})
			end
		end
	end
end)

-- ======================= EFFECTS =======================
Header(tEffects, "Trails & Particles")
local function clearTrail()
	local r = getHrp()
	if not r then return end
	for _, o in ipairs(r:GetChildren()) do
		if o.Name == "NH_TA0" or o.Name == "NH_TA1" or o.Name == "NH_Trail" then o:Destroy() end
	end
end
local function buildTrail()
	clearTrail()
	local r = getHrp()
	if not r then return end
	local a0 = N("Attachment", { Name = "NH_TA0", Position = Vector3.new(0, 1, 0), Parent = r })
	local a1 = N("Attachment", { Name = "NH_TA1", Position = Vector3.new(0, -1, 0), Parent = r })
	N("Trail", {
		Name = "NH_Trail", Attachment0 = a0, Attachment1 = a1, Lifetime = 0.7, MinLength = 0.05,
		Transparency = NumberSequence.new(0.1, 1), LightEmission = 1,
		Color = ColorSequence.new(T.AccentSoft, T.Accent), Parent = r,
	})
end
Toggle(tEffects, "Trail", "trail", function(v) if v then buildTrail() else clearTrail() end end)
Respawn.trail = buildTrail

Toggle(tEffects, "Orbit Particles", "orbit", function(v)
	Loops.orbit = nil
	local old = World:FindFirstChild("NH_Orbit")
	if old then old:Destroy() end
	if not v then return end
	local folder = N("Folder", { Name = "NH_Orbit", Parent = World })
	local parts = {}
	for i = 1, 8 do
		parts[i] = makePart({ Size = Vector3.new(0.35, 0.35, 0.35), Shape = Enum.PartType.Ball, Color = T.Accent, Parent = folder })
	end
	Loops.orbit = function()
		local r = getHrp()
		if not r then return end
		for i, p in ipairs(parts) do
			local a = tick() * 2 + i * math.pi / 4
			p.Position = r.Position + Vector3.new(math.cos(a) * 3, math.sin(a * 1.5) * 1.3, math.sin(a) * 3)
			p.Color = rainbow(i / 8)
		end
	end
end)

Toggle(tEffects, "Jump Circles", "jumpc", function(v)
	Loops.jc = nil
	if not v then return end
	local was = false
	Loops.jc = function()
		local h, r = getHum(), getHrp()
		if not h or not r then return end
		local air = h.FloorMaterial == Enum.Material.Air
		if air and not was then
			local ring = makePart({
				Size = Vector3.new(0.1, 1, 1), Transparency = 0.2, Color = T.Accent,
				CFrame = CFrame.new(r.Position - Vector3.new(0, h.HipHeight + 2.8, 0)) * CFrame.Angles(0, 0, math.pi / 2),
			})
			N("CylinderMesh", { Parent = ring })
			TS:Create(ring, TweenInfo.new(0.7, Enum.EasingStyle.Quad), { Size = Vector3.new(0.1, 9, 9), Transparency = 1 }):Play()
			Debris:AddItem(ring, 0.8)
		end
		was = air
	end
end)

Toggle(tEffects, "Step Waves", "waves", function(v)
	Loops.waves = nil
	if not v then return end
	local last = tick()
	Loops.waves = function()
		local h, r = getHum(), getHrp()
		if not h or not r then return end
		if h.MoveDirection.Magnitude > 0 and h.FloorMaterial ~= Enum.Material.Air and tick() - last > 0.25 then
			last = tick()
			local ring = makePart({
				Size = Vector3.new(0.05, 1, 1), Transparency = 0.3, Color = rainbow(),
				CFrame = CFrame.new(r.Position - Vector3.new(0, h.HipHeight + 2.7, 0)) * CFrame.Angles(0, 0, math.pi / 2),
			})
			N("CylinderMesh", { Parent = ring })
			TS:Create(ring, TweenInfo.new(0.6), { Size = Vector3.new(0.05, 5, 5), Transparency = 1 }):Play()
			Debris:AddItem(ring, 0.7)
		end
	end
end)

Toggle(tEffects, "Sparkles", "sparkles", function(v)
	local r = getHrp()
	local old = r and r:FindFirstChild("NH_Sparkles")
	if old then old:Destroy() end
	if v and r then
		N("ParticleEmitter", {
			Name = "NH_Sparkles", Rate = 25, Lifetime = NumberRange.new(0.8, 1.4), Speed = NumberRange.new(1, 3),
			SpreadAngle = Vector2.new(180, 180), LightEmission = 1, Size = NumberSequence.new(0.35, 0),
			Color = ColorSequence.new(T.AccentSoft, T.Accent), Transparency = NumberSequence.new(0, 1),
			Texture = "rbxasset://textures/particles/sparkles_main.dds", Parent = r,
		})
	end
end)
Respawn.sparkles = function() if Setters.sparkles then Setters.sparkles(false) Setters.sparkles(true) end end

Toggle(tEffects, "Fire Aura", "fire", function(v)
	local r = getHrp()
	local old = r and r:FindFirstChild("NH_Fire")
	if old then old:Destroy() end
	if v and r then N("Fire", { Name = "NH_Fire", Heat = 8, Size = 6, Color = T.Accent, SecondaryColor = T.AccentSoft, Parent = r }) end
end)
Respawn.fire = function() if Setters.fire then Setters.fire(false) Setters.fire(true) end end

Header(tEffects, "Camera")
Toggle(tEffects, "FOV Changer", "fovOn", function(v)
	if v then Loops.fov = function() Cam.FieldOfView = Flags.fov end
	else Loops.fov = nil Cam.FieldOfView = 70 end
end)
Slider(tEffects, "FOV", "fov", 40, 120, 90)
Toggle(tEffects, "Zoom (hold)", "zoom", function(v)
	if v then Loops.zoom = function() Cam.FieldOfView = 25 end
	else Loops.zoom = nil Cam.FieldOfView = Flags.fovOn and Flags.fov or 70 end
end)
Toggle(tEffects, "Unlimited Zoom Out", "unzoom", function(v)
	LP.CameraMaxZoomDistance = v and 1000 or 128
end)
Toggle(tEffects, "Third Person Lock", "tp", function(v)
		if v then LP.CameraMinZoomDistance = 10 else LP.CameraMinZoomDistance = 0.5 end
end)

-- ======================= SCREEN =======================
Header(tScreen, "Post Effects")
local function fx(class, props)
	local e = LG:FindFirstChild("NH_" .. class) or N(class, { Name = "NH_" .. class, Parent = LG })
	for k, v in pairs(props) do e[k] = v end
	return e
end
local function killfx(class) local e = LG:FindFirstChild("NH_" .. class) if e then e:Destroy() end end
Toggle(tScreen, "Bloom", "bloom", function(v) if v then fx("BloomEffect", { Intensity = 1, Size = 30, Threshold = 1 }) else killfx("BloomEffect") end end)
Toggle(tScreen, "Blur", "blur", function(v) if v then fx("BlurEffect", { Size = 8 }) else killfx("BlurEffect") end end)
Toggle(tScreen, "Sun Rays", "rays", function(v) if v then fx("SunRaysEffect", { Intensity = 0.25, Spread = 1 }) else killfx("SunRaysEffect") end end)
Toggle(tScreen, "Depth of Field", "dof", function(v)
	if v then fx("DepthOfFieldEffect", { FarIntensity = 0.4, FocusDistance = 25, InFocusRadius = 30, NearIntensity = 0 }) else killfx("DepthOfFieldEffect") end
end)
Toggle(tScreen, "Color Tint", "tint", function(v)
	if v then fx("ColorCorrectionEffect", { TintColor = C(255, 190, 185), Saturation = 0.2, Contrast = 0.1 }) else killfx("ColorCorrectionEffect") end
end)
Toggle(tScreen, "Black & White", "bw", function(v)
	if v then fx("ColorCorrectionEffect", { Saturation = -1, TintColor = C(255, 255, 255), Contrast = 0.15 })
	else killfx("ColorCorrectionEffect") end
end)
Toggle(tScreen, "Vignette", "vig", function(v)
	local g = SG:FindFirstChild("NH_Vig")
	if g then g:Destroy() end
	if v then
		N("ImageLabel", {
			Name = "NH_Vig", Size = U2(1, 0, 1, 0), BackgroundTransparency = 1, Image = "rbxassetid://5028857084",
			ImageColor3 = T.AccentDark, ImageTransparency = 0.5, ZIndex = 0, Active = false, Parent = SG,
		})
	end
end)
Toggle(tScreen, "Rainbow Tint", "rbTint", function(v)
	if v then
		Loops.rbTint = function() fx("ColorCorrectionEffect", { TintColor = rainbow():Lerp(C(255, 255, 255), 0.6), Saturation = 0.15 }) end
	else
		Loops.rbTint = nil
		killfx("ColorCorrectionEffect")
	end
end)
Toggle(tScreen, "Crosshair", "cross", function(v)
	local g = SG:FindFirstChild("NH_Cross")
	if g then g:Destroy() end
	if not v then return end
	local f = N("Frame", { Name = "NH_Cross", Size = U2(0, 20, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), Position = U2(0.5, 0, 0.5, 0), BackgroundTransparency = 1, Parent = SG })
	for _, d in ipairs({ { 8, 0, 4, 7 }, { 8, 13, 4, 7 }, { 0, 8, 7, 4 }, { 13, 8, 7, 4 } }) do
		N("Frame", { Position = U2(0, d[1], 0, d[2]), Size = U2(0, d[3], 0, d[4]), BackgroundColor3 = T.Accent, BorderSizePixel = 0, Parent = f })
	end
end)

-- ======================= MISC =======================
Header(tMisc, "Utility")
local afkConn
Toggle(tMisc, "Anti AFK", "afk", function(v)
	if afkConn then afkConn:Disconnect() afkConn = nil end
	if v then
		afkConn = LP.Idled:Connect(function()
			VU:CaptureController()
			VU:ClickButton2(Vector2.new())
		end)
	end
end)
Toggle(tMisc, "Show HUD", "hudShow", function(v) HC.Visible = v end)
Toggle(tMisc, "Show ArrayList", "alShow", function(v) AL.Visible = v end)
Setters.hudShow(true)
Setters.alShow(true)
Button(tMisc, "Unload Script", function()
	for _, n in ipairs((function() local t = {} for k in pairs(Acc) do t[#t + 1] = k end return t end)()) do accKill(n) end
	for k in pairs(Loops) do Loops[k] = nil end
	for _, c in pairs({ afkConn }) do pcall(function() c:Disconnect() end) end
	LP.CameraMaxZoomDistance, LP.CameraMinZoomDistance = 128, 0.5
	Cam.FieldOfView = 70
	LG.FogStart, LG.FogEnd, LG.FogColor = fogBackup.s, fogBackup.e, fogBackup.c
	LG.Brightness, LG.Ambient, LG.OutdoorAmbient, LG.GlobalShadows, LG.ClockTime = lt.B, lt.A, lt.O, true, lt.T
	if atmo and atmoBackup then atmo.Density, atmo.Offset = atmoBackup.d, atmoBackup.o end
	for _, s in ipairs(origSkies) do if not s.Parent then s.Parent = LG end end
	for _, e in ipairs(LG:GetChildren()) do if e.Name:sub(1, 3) == "NH_" then e:Destroy() end end
	local c = LP.Character
	if c then
		for _, d in ipairs(c:GetDescendants()) do if d.Name:sub(1, 3) == "NH_" then d:Destroy() end end
	end
	World:Destroy()
	SG:Destroy()
end)
