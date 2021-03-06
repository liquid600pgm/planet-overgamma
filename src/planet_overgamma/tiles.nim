## All sort of tile-related stuff.

import aglet/rect

import items
import registry
import tileset


# block

type
  BlockGraphicKind* = enum
    bgkSingle
    bgkAutotile

  BlockId* = RegistryId[Block]

  Block* = object
    ## A block descriptor is a unique object stored in the block registry.
    ## Block descriptors include all the significant information about a block:
    ## its graphic, translation ID, hardness, etc.

    id*: BlockId

    case graphicKind*: BlockGraphicKind
    of bgkSingle:
      graphic*: Rectf
    of bgkAutotile:
      patch*: BlockPatch

    isSolid*: bool
      ## Controls whether the player can collide with the block.
    hardness*: float32
      ## Controls how difficult the block is to destroy.
      ## The player's laser must charge up *at least* to this value before the
      ## block is destroyed.
    drops*: ItemDrops
      ## The items dropped when the tile is destroyed.

  BlockRegistry* = Registry[Block]

proc initBlock*(graphic: Rectf, isSolid: bool, hardness: float32,
                drops: ItemDrops): Block =
  ## Creates a new single-graphic block.
  Block(
    graphicKind: bgkSingle,
    graphic: graphic,
    isSolid: isSolid,
    hardness: hardness,
    drops: drops,
  )

proc initBlock*(patch: BlockPatch, isSolid: bool, hardness: float32,
                drops: ItemDrops): Block =
  ## Creates a new auto-tile block.
  Block(
    graphicKind: bgkAutotile,
    patch: patch,
    isSolid: isSolid,
    hardness: hardness,
    drops: drops,
  )


# tile

type
  TileKind* = enum
    tkEmpty
    tkBlock

  Tile* = object
    ## A single map tile. Most of the fields are IDs for efficiency and easy
    ## serialization.

    case kind*: TileKind
    of tkEmpty: discard
    of tkBlock:
      blockId*: BlockId
      isSolid*: bool

proc `==`*(a, b: Tile): bool =
  ## Compares two tiles for equality.

  if a.kind != b.kind: return false

  case a.kind
  of tkEmpty: true
  of tkBlock: a.blockId == b.blockId

proc connectsTo*(a, b: Tile): bool =
  ## Returns whether two tiles should connect to each other.
  # for now this is just a simple equality comparison, but this may get extended
  # at some point
  a == b

const
  emptyTile* = Tile(kind: tkEmpty)
    ## Empty tile constant.

proc blockTile*(br: BlockRegistry, id: BlockId): Tile =
  ## Creates a new block tile.
  Tile(kind: tkBlock, blockId: id, isSolid: br.get(id).isSolid)
