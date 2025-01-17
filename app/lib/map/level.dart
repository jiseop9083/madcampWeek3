import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'package:app/Components/collistionBlock.dart';
import 'package:app/Components/Player.dart';

class Level extends World {
  late Player player;

  Level({required this.player});
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  setPlayer(Player player) {
    this.player = player;
  }

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('Game.tmx', Vector2.all(64));
    add(level);
    final metaDataLayer = level.tileMap.getLayer<ObjectGroup>('Metadata');
    for (final metaData in metaDataLayer!.objects) {
      switch (metaData.class_) {
        case 'Player':
          player.position = Vector2(metaData.x, metaData.y);
          add(player);
          break;
        case 'EndPoint':
          final endPoint = CollisionBlock(
            position: Vector2(metaData.x, metaData.y),
            size: Vector2(metaData.width, metaData.height),
            isEnd: true,
          );
          collisionBlocks.add(endPoint);
          add(endPoint);
          break;
      }
    }

    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null) {
      for (final collision in collisionsLayer!.objects) {
        switch (collision.class_) {
          case 'Water':
            final water = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isWater: true,
            );
            collisionBlocks.add(water);
            add(water);
            break;
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          case 'Slope':
            final properties = collision.properties;
            final IntProperty leftProperty =
                properties['leftTop'] as IntProperty;
            int leftTop = leftProperty.value;
            final IntProperty rightProperty =
                properties['rightTop'] as IntProperty;
            int rightTop = rightProperty.value;
            final block = CollisionBlock(
                position: Vector2(collision.x, collision.y),
                size: Vector2(collision.width, collision.height),
                isPlatform: false,
                isSlope: true,
                leftTop: leftTop,
                rightTop: rightTop);
            collisionBlocks.add(block);
            add(block);
            break;
          default: //normal block
            final block = CollisionBlock(
                position: Vector2(collision.x, collision.y),
                size: Vector2(collision.width, collision.height),
                isPlatform: false);
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
    return super.onLoad();
  }
}
