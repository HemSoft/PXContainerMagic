PXContainerMagic = {
  Name = "PXContainerMagic",
  Version = "0.0.1",
  LootInitiated = false
}

---------------------------------------------------------------------------------------------------------
-- Initialize:
---------------------------------------------------------------------------------------------------------
function PXContainerMagic.OnAddOnLoaded(event, addonName)
  -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
  if addonName == PXContainerMagic.Name then
    d('PXCM -- OnAddOnLoaded')
    PXContainerMagic:Initialize()
  end
end

function PXContainerMagic:Initialize()
  d('PXCM -- Initialize')
  ZO_CreateStringId("SI_BINDING_NAME_PX_CONTAINER_MAGIC_OPEN", "Open all containers")
end

function PXContainerMagic.OnLootUpdated()
  if (PXContainerMagic.LootInitiated == true) then
    LootAll()
    PXContainerMagic.LootInitiated = false

    local n = SCENE_MANAGER:GetCurrentScene().name
    if n == 'hudui' or n == 'interact' or n == 'hud' then
      SCENE_MANAGER:Show('hud')
	else
      SCENE_MANAGER:Show(n)
    end
  end
end

---------------------------------------------------------------------------------------------------------
-- KEYBINDING EVENTS:
---------------------------------------------------------------------------------------------------------
function PXContainerMagic_OpenContainers()
  local inventoryCount = GetNumBagUsedSlots(INVENTORY_BACKPACK)
  d('PXCM -- PXContainerMagic_OpenContainers()')

  for x = 1, inventoryCount do
    local link = GetItemLink(INVENTORY_BACKPACK, x)
    local itemType =  GetItemType(INVENTORY_BACKPACK, x)

    if (itemType == ITEMTYPE_CONTAINER) then
      if IsProtectedFunction("UseItem") then
        d("PXCM -- Attempting to open container " .. link)
        CallSecureProtected("UseItem", INVENTORY_BACKPACK, x)
        PXContainerMagic.LootInitiated = true
        --zo_callLater(function() LootAll(true) end, 300)
      else
        UseItem(INVENTORY_BACKPACK, x)
      end 
    end
  end
end

EVENT_MANAGER:RegisterForEvent(PXContainerMagic.Name, EVENT_ADD_ON_LOADED, PXContainerMagic.OnAddOnLoaded)
EVENT_MANAGER:RegisterForEvent(PXContainerMagic.name, EVENT_LOOT_UPDATED , PXContainerMagic.OnLootUpdated)