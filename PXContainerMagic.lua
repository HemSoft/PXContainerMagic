PXContainerMagic = {
  Name = "PXContainerMagic",
  Version = "1.0.0",
  LootInitiated = false
}

---------------------------------------------------------------------------------------------------------
-- Initialize:
---------------------------------------------------------------------------------------------------------
function PXContainerMagic.OnAddOnLoaded(event, addonName)
  -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
  if addonName == PXContainerMagic.Name then
    d('PXCM -- OnAddOnLoaded')
    Initialize()
  end
end

function PXContainerMagic.OnLootUpdated()
  if (PXContainerMagic.LootInitiated == true) then
    d('PXCM -- PXContainerMagic.OnLootUpdated()')
    LootAll()
    PXContainerMagic.LootInitiated = false

    local n = SCENE_MANAGER:GetCurrentScene().name
    if n == 'hudui' or n == 'interact' or n == 'hud' then
      SCENE_MANAGER:Show('hud')
	  else
      SCENE_MANAGER:Show(n)
    end

    zo_calllater(OpenContainers, 1000)
  end
end

function Initialize()
  d('PXCM -- Initialize')
  ZO_CreateStringId("SI_BINDING_NAME_PX_CONTAINER_MAGIC_OPEN", "Open all containers")
end

function OpenContainers()
  local inventoryCount = GetBagSize(INVENTORY_BACKPACK)
  d('PXCM -- PXContainerMagic:OpenContainers()')

  for x = 0, inventoryCount do
    local link = GetItemLink(INVENTORY_BACKPACK, x)
    local itemType =  GetItemType(INVENTORY_BACKPACK, x)

    if (itemType == ITEMTYPE_CONTAINER) then
      d('PXCM -- Opening ' .. link)
      openContainer(INVENTORY_BACKPACK, x)
      break
    end
  end
end

function openContainer(bag, slot)
  lastScene = SCENE_MANAGER:GetCurrentScene():GetName()
  if lastScene == "interact" then
    LootAll()
    lastScene = "hudui"
  end
  
  if IsProtectedFunction("UseItem") then
    --d("Attempting to open container "..GetItemLink(bag, slot))
    CallSecureProtected("UseItem", bag, slot)
  else
    UseItem(bag, slot)
  end 
  calledFromQuest = true
  LootAll()
  zo_callLater(OpenContainers, 1000)
end

---------------------------------------------------------------------------------------------------------
-- KEYBINDING EVENTS:
---------------------------------------------------------------------------------------------------------
EVENT_MANAGER:RegisterForEvent(PXContainerMagic.Name, EVENT_ADD_ON_LOADED, PXContainerMagic.OnAddOnLoaded)
EVENT_MANAGER:RegisterForEvent(PXContainerMagic.name, EVENT_LOOT_UPDATED , PXContainerMagic.OnLootUpdated)