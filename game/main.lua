-- main.lua

--[[
BOLT-LOVE Juego Pixel Art, para aprender Framework LOVE2D.
--]]

-- overlayStats para debugging
local overlayStats = require("lib.overlayStats")

-- Definir un objeto Vector con métodos útiles
local Vector = {}
Vector.__index = Vector

function Vector:new(x, y)
  return setmetatable({ x = x, y = y }, self)
end

function Vector:copy()
  return Vector:new(self.x, self.y)
end

function Vector:add(v)
  self.x = self.x + v.x
  self.y = self.y + v.y
  return self
end

function Vector:rotate(angle)
  local cosA = math.cos(angle)
  local sinA = math.sin(angle)
  local x = self.x * cosA - self.y * sinA
  local y = self.x * sinA + self.y * cosA
  self.x = x
  self.y = y
  return self
end

function Vector:normalize()
  local len = math.sqrt(self.x * self.x + self.y * self.y)
  if len > 0 then
    self.x = self.x / len
    self.y = self.y / len
  end
  return self
end

function Vector:mul(scalar)
  self.x = self.x * scalar
  self.y = self.y * scalar
  return self
end

function Vector:length()
  return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector:distance(other)
  local dx = self.x - other.x
  local dy = self.y - other.y
  return math.sqrt(dx * dx + dy * dy)
end

-- Función de conveniencia para crear un vector
function vec(x, y)
  return Vector:new(x, y)
end

-- Genera número aleatorio decimal, a inclusivo, b exclusivo
function rnd(a, b)
  return love.math.random() * (b - a) + a
end
-- Genera número aleatorio entero, a inclusivo, b inclusivo
function rndi(a, b)
  return love.math.random(a, b)
end
-- Función para generar números aleatorios en rango [-a, a]
function rnds(a)
  return love.math.random() * 2 * a - a
end

-- Colores definidos en escala 0-1
local colors = {
  light_blue = { 0.678, 0.847, 0.901 },
  dark_slate_blue = { 0.28, 0.24, 0.54 },
  dark_blue = { 0.035, 0.047, 0.106 },
  light_black = { 0.411, 0.411, 0.411 },
  fire_orange = { 1, 0.5, 0.1 },
  spark_white = { 0.9, 0.9, 1 },
  yellow = { 1, 1, 0 },
  red = { 1, 0, 0 },
  green = { 0, 1, 0 },
  black = { 0, 0, 0 },
  white = { 1, 1, 1 },
}

-- Sprites del protagonista (matrices 16x16 con animación)
local playerSprites = {
  idle = {
    {
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0 },
      { 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0 },
    },
    {
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0 },
      { 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0 },
    },
  },
  running = {
    {
      { 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0 },
      { 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0 },
      { 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0 },
      { 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0 },
      { 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0 },
      { 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0 },
    },
    {
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0 },
      { 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0 },
      { 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0 },
      { 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0 },
      { 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0 },
    },
  },
  dead = {
    {
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0 },
    },
  },
}

-- Variables globales del juego
local ticks = 0
local difficulty = 1
local maxDifficulty = 3
local lines = {}
local activeTicks = -1
local stars = {}
local player = {}
local multiplier = 1
local score = 0
local hiScore = 0
local gameState = "playing"
local gameOverTimer = 0
local sparks = {} -- Chispas en las bifurcaciones
-- Variables para almacenar las fuentes
local bigFont, instructionsFont, pixelFont, smallerInstructionFont

-- Variables para efectos visuales
local scorePopups = {}

-- Variables de animación
local animationTimer = 0
local currentFrame = 1
-- Audio
local lastHitTime = 0
local hitCooldown = 0.2 -- segundos entre reproducciones del sonido 'hit'
-- Attract mode
local attractMode = true
local attractPlayerDirectionChangeTimer = 0
local attractInstructionTimer = 0
local attractInstructionVisible = true
-- Habilitar el overlayStats info, cambiar si es visible con f3
local isDebugEnabled = true

-- Configuración de ventana
function love.load()
  love.window.setTitle("BOLT-LOVE")
  love.window.setMode(800, 800)
  -- love.math.setRandomSeed(3) -- el seed 3 sirve para morir rápido

  sounds = {}
  generateSound("laser")
  generateSound("explosion")
  generateSound("coin")
  generateSound("hit")

  love.graphics.setBackgroundColor(colors.dark_blue)

  -- Configurar filtros para pixel art
  love.graphics.setDefaultFilter("nearest", "nearest")

  -- Crear fuentes pixeladas
  bigFont = love.graphics.newFont("8-bit-pusab.ttf", 56)
  bigFont:setFilter("nearest", "nearest")

  instructionsFont = love.graphics.newFont("8-bit-pusab.ttf", 24)
  instructionsFont:setFilter("nearest", "nearest")
  smallerInstructionFont = love.graphics.newFont("8-bit-pusab.ttf", 20)

  pixelFont = love.graphics.newFont("8-bit-pusab.ttf", 32)
  pixelFont:setFilter("nearest", "nearest")
  love.graphics.setFont(pixelFont)

  -- Inicializar el juego
  initGame()
  -- debug info
  if isDebugEnabled then
    overlayStats.load()
  end
end

-- Función para inicializar/reiniciar el juego
function initGame()
  ticks = 0
  lines = {}
  activeTicks = -1
  stars = {}
  sparks = {}
  player = { x = rndi(40, 80), vx = 1, size = 3.5, animState = "idle" }
  multiplier = 1
  score = 0
  difficulty = 1
  gameState = attractMode and "attract" or "playing"
  gameOverTimer = 0
  scorePopups = {}
  animationTimer = 0
  currentFrame = 1
  attractPlayerDirectionChangeTimer = 0
  attractInstructionTimer = 0
  attractInstructionVisible = true
end

-- Función para dibujar sprite pixelado
function drawSprite(sprite, x, y, pixelSize, flipX)
  local startX = x - (#sprite[1] * pixelSize) / 2
  local startY = y - (#sprite * pixelSize) / 2

  for row = 1, #sprite do
    for col = 1, #sprite[row] do
      if sprite[row][col] == 1 then
        local px = startX + (col - 1) * pixelSize
        local py = startY + (row - 1) * pixelSize

        if flipX then
          px = startX + (#sprite[row] - col) * pixelSize
        end

        love.graphics.rectangle("fill", px, py, pixelSize, pixelSize)
      end
    end
  end
end

-- Función para dibujar líneas segmentadas con chispas
function drawSegmentedLine(from, to, color, width, isActive)
  love.graphics.setColor(color)
  love.graphics.setLineWidth(width)

  local dx = to.x - from.x
  local dy = to.y - from.y
  local length = math.sqrt(dx * dx + dy * dy)

  if length < 5 then
    -- Línea muy corta, dibujar completa
    love.graphics.line(from.x, from.y, to.x, to.y)
    return
  end

  -- Dividir la línea en segmentos
  local segmentLength = rnd(3, 8)
  local segments = math.floor(length / segmentLength)

  local unitX = dx / length
  local unitY = dy / length

  local currentX = from.x
  local currentY = from.y

  for i = 1, segments do
    local segLen = segmentLength + rnd(-1, 1)
    local endX = currentX + unitX * segLen
    local endY = currentY + unitY * segLen

    -- Añadir algo de ruido a la línea para efecto eléctrico
    if isActive and gameState ~= "gameOver" then
      endX = endX + rnd(-0.5, 0.5)
      endY = endY + rnd(-0.5, 0.5)
    end

    -- La línea principal del rayo, que cubre las ramas
    love.graphics.line(currentX, currentY, endX, endY)

    -- Agregar chispa ocasional en segmentos activos
    if isActive and love.math.random() < 0.3 and gameState ~= "gameOver" then
      table.insert(sparks, {
        pos = vec(endX, endY),
        vel = vec(rnd(-2, 2), rnd(-2, 2)),
        life = rnd(10, 30),
        maxLife = 30,
        size = 1,
        isYellow = isActive,
      })
    end

    currentX = endX
    currentY = endY
  end

  -- Dibujar el último segmento hasta el final
  if currentX ~= to.x or currentY ~= to.y then
    love.graphics.line(currentX, currentY, to.x, to.y)
  end
end

-- Función auxiliar para remover elementos de una tabla según un predicado
function remove(tbl, predicate)
  for i = #tbl, 1, -1 do
    if predicate(tbl[i]) then
      table.remove(tbl, i)
    end
  end
end

-- Funciones para sonido y efectos
function play(name)
  local s = sounds[name]
  if s then
    s:stop()
    s:play()
  end
end

function generateSound(name)
  local params = {
    laser = { startFreq = 1200, endFreq = 100, duration = 0.1, volume = 0.4 },
    hit = { startFreq = 400, endFreq = 40, duration = 0.15, volume = 0.5 },
    coin = { startFreq = 800, endFreq = 1600, duration = 0.07, volume = 0.4 },
    explosion = { startFreq = 200, endFreq = 50, duration = 0.2, volume = 1 },
  }

  local p = params[name]
  if not p then
    return
  end

  local sampleRate = 44100
  local bitDepth = 16
  local channels = 1
  local sampleCount = math.floor(sampleRate * p.duration)
  local soundData = love.sound.newSoundData(sampleCount, sampleRate, bitDepth, channels)

  for i = 0, sampleCount - 1 do
    local t = i / sampleRate
    local freq
    if name == "coin" then
      -- Coin sube en tono
      freq = p.startFreq + (p.endFreq - p.startFreq) * (t / p.duration)
    else
      -- Otros sonidos decaen
      freq = p.startFreq * ((p.endFreq / p.startFreq) ^ (t / p.duration))
    end
    local value = math.sin(2 * math.pi * freq * t) > 0 and p.volume or -p.volume
    soundData:setSample(i, value)
  end

  sounds[name] = love.audio.newSource(soundData)
end

function addScore(mult, pos)
  score = score + mult * 1
  table.insert(scorePopups, {
    pos = pos:copy(),
    value = mult * 1,
    timer = 60,
    vel = vec(0, -0.5),
  })
end

-- Función para detectar colisión punto-línea
function pointToLineDistance(px, py, x1, y1, x2, y2)
  local A = px - x1
  local B = py - y1
  local C = x2 - x1
  local D = y2 - y1

  local dot = A * C + B * D
  local lenSq = C * C + D * D

  if lenSq == 0 then
    return math.sqrt(A * A + B * B)
  end

  local param = dot / lenSq

  local xx, yy
  if param < 0 then
    xx, yy = x1, y1
  elseif param > 1 then
    xx, yy = x2, y2
  else
    xx = x1 + param * C
    yy = y1 + param * D
  end

  local dx = px - xx
  local dy = py - yy
  return math.sqrt(dx * dx + dy * dy)
end

-- Función para detectar colisión círculo-círculo
function circleCollision(x1, y1, r1, x2, y2, r2)
  local dx = x1 - x2
  local dy = y1 - y2
  local distance = math.sqrt(dx * dx + dy * dy)
  return distance < (r1 + r2)
end

-- Función para reiniciar el juego
function restartGame()
  if gameState == "gameOver" and gameOverTimer > 60 then
    initGame()
  end
end

-- Variable para detectar si se presionó una tecla
local justPressed = false
function love.keypressed(key)
  if (key == "space" or key == "return" or key == "left" or key == "right") and attractMode then
    attractMode = false
    initGame()
    return
  end

  if key == "space" or key == "return" or key == "left" or key == "right" then
    justPressed = true
    if gameState == "gameOver" then
      restartGame()
    end
    play("laser")
  end
  if key == "r" then
    initGame()
  end
  if key == "escape" then
    love.event.quit()
  end
  -- debug info
  if isDebugEnabled then
    overlayStats.handleKeyboard(key)
  end
end

function love.mousepressed(x, y, button)
  if button == 1 and attractMode then
    attractMode = false
    initGame()
    return
  end

  if button == 1 then
    justPressed = true
    if gameState == "gameOver" then
      restartGame()
    end
  end
end

function updateDifficulty()
  if score >= 3000 then
    difficulty = 3
  elseif score >= 1000 then
    difficulty = 2
  else
    difficulty = 1
  end
end

local elapsedTime = 0
function love.update(dt)
  -- Tiempo transcurrido
  elapsedTime = elapsedTime + dt

  -- Actualizar animaciones
  animationTimer = animationTimer + 1
  if animationTimer % 15 == 0 then -- Cambiar frame cada 15 ticks
    currentFrame = currentFrame + 1
  end

  if gameState == "gameOver" then
    gameOverTimer = gameOverTimer + 1
    player.animState = "dead"
    justPressed = false
    -- En attract mode, reiniciar automáticamente después de game over
    if attractMode and gameOverTimer > 60 then
      initGame()
    end
    return
  end

  ticks = ticks + 1

  -- Lógica específica del attract mode
  if attractMode then
    -- Cambiar dirección del jugador automáticamente
    attractPlayerDirectionChangeTimer = attractPlayerDirectionChangeTimer + 1
    if attractPlayerDirectionChangeTimer >= math.random(150, 250) then
      player.vx = -player.vx
      attractPlayerDirectionChangeTimer = 0
    end
  end

  if ticks == 1 then
    -- dirección inicial del player, pero solo -1 o 1
    local vxInicial = rndi(0, 1) * 2 - 1
    lines = {}
    activeTicks = -1
    stars = {}
    sparks = {}
    player = { x = rndi(20, 80), vx = vxInicial, size = 3.5, animState = "idle" }
    multiplier = 1
  end

  -- Determinar estado de animación del jugador
  if math.abs(player.vx) > 0.5 then
    player.animState = "running"
  else
    player.animState = "idle"
  end

  -- Si no hay líneas activas, se crea la primera
  if #lines == 0 then
    local from = vec(rnd(20, 80), 0)
    table.insert(lines, {
      from = from:copy(),
      to = from:copy(),
      vel = vec(0.5 * math.sqrt(difficulty), 0):rotate(math.pi / 2), -- Crecimiento más suave
      ticks = 30, -- math.ceil(30 / difficulty)
      prevLine = nil,
      isActive = false,
      drawWidth = 1,
    })
  end
  activeTicks = activeTicks - 1

  -- Procesar cada línea y actualizar su estado
  remove(lines, function(l)
    if l.isActive then
      l.drawWidth = 2
      -- Agregar chispa segmento activo final que colisiona con el piso
      if gameState ~= "gameOver" then
        table.insert(sparks, {
          pos = vec(l.to.x, 87),
          vel = vec(rnd(-2, 2), rnd(-2, 2)),
          life = rnd(20, 40),
          maxLife = 40,
          size = math.floor(rnd(1, 3)),
          isFire = true,
        })
      end

      -- Colisión con líneas activas (amarillas)
      local distToLine = pointToLineDistance(player.x, 87, l.from.x, l.from.y, l.to.x, l.to.y)
      if distToLine < player.size then
        play("explosion")
        gameState = "gameOver"
        gameOverTimer = 0
        return false
      end

      return activeTicks < 0
    end

    l.ticks = l.ticks - 1
    if activeTicks > 0 then
      if l.ticks > 0 then
        table.insert(stars, {
          pos = l.to:copy(),
          vel = vec(0, -l.to.y * 0.02),
          size = 1.5,
        })
      end
      return true
    end

    if l.ticks > 0 then
      l.to:add(l.vel)
      if activeTicks < 0 and (l.to.y > 90 or #lines > 1000) then
        play("explosion")
        local al = l
        for i = 1, 99 do
          al.isActive = true
          al = al.prevLine
          if not al then
            break
          end
        end

        -- tiempo que pasa el rayo activo
        activeTicks = math.ceil(rnd(30, 30 * math.sqrt(difficulty)))
        multiplier = 1
      end
    elseif l.ticks == 0 then
      if elapsedTime - lastHitTime > hitCooldown then
        play("hit")
        lastHitTime = elapsedTime
      end

      -- Agregar chispas en la bifurcación
      for i = 1, rndi(3, 8) do
        table.insert(sparks, {
          pos = l.to:copy(),
          vel = vec(rnd(-3, 3), rnd(-3, 3)),
          life = rnd(20, 40),
          maxLife = 40,
          size = 1,
        })
      end
      -- Actualizar la dificultad según la puntuación
      updateDifficulty()

      -- Crear las bifurcaciones del rayo
      local numNew
      if difficulty == 1 then
        numNew = rndi(1, 4) -- Para dificultad mínima: 1 o 4 bifurcaciones
      else
        numNew = rndi(1, 3) -- Para otras dificultades
      end
      for i = 1, numNew do
        local newVel = vec(l.vel.x, l.vel.y):normalize():rotate(rnds(0.5))
        newVel:mul(rnd(0.3, 1)) -- * math.sqrt(difficulty))
        table.insert(lines, {
          from = l.to:copy(),
          to = l.to:copy(),
          vel = newVel,
          ticks = math.ceil(rnd(20, 40) / math.sqrt(difficulty)),
          prevLine = l,
          isActive = false,
          drawWidth = 1,
        })
      end
    end
    l.drawWidth = 1
    return false
  end)

  -- Verificar entrada
  if justPressed or (player.x < 0 and player.vx < 0) or (player.x > 99 and player.vx > 0) then
    play("laser")
    player.vx = -player.vx
  end

  -- Actualizar la posición del jugador
  player.x = player.x + player.vx * math.sqrt(difficulty)

  -- Actualizar las estrellas y verificar colisiones
  remove(stars, function(s)
    s.vel.y = s.vel.y + 0.1 * difficulty
    s.pos:add(s.vel)

    -- Colisión con estrellas
    if circleCollision(player.x, 87, player.size, s.pos.x, s.pos.y, s.size) then
      play("coin")
      addScore(multiplier, s.pos)
      multiplier = multiplier + 1
      return true
    end

    if s.pos.y > 89 and s.vel.y > 0 then
      s.vel.y = s.vel.y * -0.5
      if s.vel.y > -0.1 then
        return true
      end
    end

    return false
  end)

  -- Actualizar chispas
  remove(sparks, function(spark)
    spark.life = spark.life - 1
    spark.pos:add(spark.vel)
    spark.vel:mul(0.95) -- Fricción
    spark.vel.y = spark.vel.y + 0.05 -- Gravedad leve
    -- Comportamiento especial para chispas de fuego:
    if spark.isFire then
      spark.vel.y = spark.vel.y - 0.15 -- Fuego sube (gravedad negativa más fuerte)
      spark.vel.x = spark.vel.x * 0.85 -- Fricción horizontal más pronunciada
    end
    return spark.life <= 0
  end)

  -- Actualizar popups de puntuación
  remove(scorePopups, function(popup)
    popup.timer = popup.timer - 1
    popup.pos:add(popup.vel)
    popup.vel.y = popup.vel.y - 0.02
    return popup.timer <= 0
  end)

  justPressed = false

  -- debug info
  if isDebugEnabled then
    overlayStats.update(dt)
  end
end

-- Dibujar una estrella con un polígono
local function drawStar(x, y, r)
  local points = {}
  local spikes = 5
  local step = math.pi / spikes

  for i = 0, 2 * spikes - 1 do
    local radius = (i % 2 == 0) and r or r * 0.5
    local angle = i * step - math.pi / 2
    table.insert(points, x + math.cos(angle) * radius)
    table.insert(points, y + math.sin(angle) * radius)
  end

  love.graphics.polygon("fill", points)
end

function love.draw()
  love.graphics.push()
  love.graphics.scale(8, 8)

  -- Dibujar el suelo
  love.graphics.setColor(colors.dark_slate_blue)
  love.graphics.rectangle("fill", 0, 90, 100, 10)

  -- Dibujar cada línea con segmentación
  for _, l in ipairs(lines) do
    local color = l.isActive and colors.yellow or colors.light_blue
    drawSegmentedLine(l.from, l.to, color, l.drawWidth, l.isActive)
  end

  -- Dibujar las chispas
  love.graphics.setColor(colors.spark_white)
  for _, spark in ipairs(sparks) do
    local pixelSize = 1
    local alpha = spark.life / spark.maxLife
    if spark.isYellow then
      love.graphics.setColor(colors.yellow[1], colors.yellow[2], colors.yellow[3], alpha)
    elseif spark.isFire then
      pixelSize = math.floor(spark.size)
      local flicker = rnd(1, 1.2) -- Pequeña variación en el brillo
      love.graphics.setColor(
        math.min(1, colors.fire_orange[1] * flicker),
        math.min(1, colors.fire_orange[2] * flicker * 0.8),
        math.min(1, colors.fire_orange[3] * flicker * 0.5),
        alpha
      )
    else
      love.graphics.setColor(colors.spark_white[1], colors.spark_white[2], colors.spark_white[3], alpha)
    end
    -- Los sparks
    love.graphics.rectangle("fill", spark.pos.x - spark.size / 2, spark.pos.y - spark.size / 2, pixelSize, pixelSize)
  end

  -- Dibujar las estrellas
  love.graphics.setColor(colors.yellow)
  for _, s in ipairs(stars) do
    local x, y = s.pos.x, s.pos.y
    local size = math.max(2, s.size) -- mínimo para que se vea
    drawStar(x, y, size)
  end

  -- Dibujar el jugador usando sprites pixelados
  local sprites = playerSprites[player.animState]
  if sprites then
    local frameIndex = ((currentFrame - 1) % #sprites) + 1
    local sprite = sprites[frameIndex]

    if gameState == "gameOver" then
      love.graphics.setColor(colors.red)
    else
      love.graphics.setColor(colors.white)
    end
    -- Dibuja el player
    drawSprite(sprite, player.x, 89, 0.5, player.vx < 0)
  end

  love.graphics.pop()

  -- UI: Dibujar puntuación y información con fuente pixelada, solo si no estamos en attract mode
  if not attractMode then
    love.graphics.setFont(pixelFont)
    love.graphics.setColor(colors.white)
    love.graphics.print(score, 10, 10)
    -- Tamaño del texto completo
    local hiScoreText = "HI: " .. hiScore
    -- El ancho en píxeles
    local textWidth = love.graphics.getFont():getWidth(hiScoreText)
    -- Dibujar el texto del HiScore a la derecha de la pantalla
    love.graphics.print(hiScoreText, 800 - textWidth - 10, 10) -- 10px de margen derecho
  end

  -- Dibujar popups de puntuación
  for _, popup in ipairs(scorePopups) do
    local alpha = popup.timer / 60
    love.graphics.setColor(colors.green[1], colors.green[2], colors.green[3], alpha)
    love.graphics.print("+" .. popup.value, popup.pos.x * 8, popup.pos.y * 8)
  end

  -- Pantalla de Attract Mode
  if attractMode then
    love.graphics.setColor(0, 0, 0, 0.4)
    love.graphics.rectangle("fill", 0, 0, 800, 800)

    love.graphics.setColor(colors.yellow)
    love.graphics.setFont(bigFont)
    love.graphics.print("BOLT-LOVE", 110, 200)

    love.graphics.setColor(colors.white)
    love.graphics.setFont(instructionsFont)
    love.graphics.print("DODGE THE LIGHTNING BOLTS!", 70, 300)
    love.graphics.print("COLLECT STARS FOR POINTS", 90, 340)

    -- Instrucción parpadeante
    if attractInstructionVisible then
      love.graphics.print("PRESS SPACE OR CLICK TO START", 40, 440)
      love.graphics.print("AND TO CHANGE DIRECTION", 100, 480)
    end
    love.graphics.setFont(smallerInstructionFont)
    love.graphics.print("https://github.com/plinkr/bolt-love", 70, 550)
  end

  -- Pantalla de Game Over
  if gameState == "gameOver" and not attractMode then
    love.graphics.setColor(0, 0, 0, 0.65)
    love.graphics.rectangle("fill", 0, 0, 800, 800)

    love.graphics.setColor(colors.red)
    love.graphics.setFont(bigFont)
    love.graphics.print("GAME OVER", 120, 300)

    -- Actualizar el Hi Score
    if score > hiScore then
      hiScore = score
    end

    if gameOverTimer > 60 then
      love.graphics.setColor(colors.white)
      love.graphics.setFont(instructionsFont)
      love.graphics.print("PRESS SPACE OR CLICK TO RESTART", 10, 420)
      love.graphics.print("PRESS R TO RESTART ANYTIME", 70, 480)
    end
  end
  -- debug info
  if isDebugEnabled then
    overlayStats.draw()
  end
end
