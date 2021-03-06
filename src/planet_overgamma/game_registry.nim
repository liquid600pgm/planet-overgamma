## Master object holding all the smaller registries.

import items
import registry
import tiles
import world_generation_base

export registry

type
  GameRegistry* = ref object
    ## Registry for all game data.

    blockRegistry*: BlockRegistry
    itemRegistry*: ItemRegistry
    worldGenRegistry*: WorldGeneratorRegistry
