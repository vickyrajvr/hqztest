//  This file is part of an img.ly Software Development Kit.
//  Copyright (C) 2016-2022 img.ly GmbH <contact@img.ly>
//  All rights reserved.
//  Redistribution and use in source and binary forms, without
//  modification, are permitted provided that the following license agreement
//  is approved and a legal/financial contract was signed by the user.
//  The license agreement can be found under the following link:
//  https://img.ly/tos

/**
 *  Represents the changes that should be rendered by an instance of `PhotoEditRenderer`.
 */
typedef NS_OPTIONS(NSUInteger, PESDKRenderMode) {
  /**
   *  No changes should be rendered.
   */
  PESDKRenderModeNone = 0,
  /**
   *  Auto-Enhancement should be rendered.
   */
  PESDKRenderModeAutoEnhancement = 1 << 0,
  /**
   *  Orientation, Crop and Angle changes should be rendered.
   */
  PESDKRenderModeTransform = 1 << 1,
  /**
   *  Focus should be rendered.
   */
  PESDKRenderModeFocus = 1 << 2,
  /**
   *  Filters should be rendered.
   */
  PESDKRenderModeEffect = 1 << 3,
  /**
   *  Color adjustments should be rendered.
   */
  PESDKRenderModeColorAdjustments = 1 << 4,
  /**
   *  Sprites (Stickers, Text and Frames) should be rendered.
   */
  PESDKRenderModeSprites = 1 << 5,
  /**
   *  Inset should be rendered.
   */
  PESDKRenderModeInset = 1 << 6,
  /**
   *  Overlay should be rendered.
   */
  PESDKRenderModeOverlay = 1 << 7,
  /**
   *  Background should be removed.
   */
  PESDKRenderModeBackgroundRemoval = 1 << 8,
  /**
   *  Everything should be rendered.
   */
  PESDKRenderModeAll = PESDKRenderModeAutoEnhancement | PESDKRenderModeTransform |
  PESDKRenderModeFocus | PESDKRenderModeEffect | PESDKRenderModeColorAdjustments |
  PESDKRenderModeSprites | PESDKRenderModeInset | PESDKRenderModeOverlay | PESDKRenderModeBackgroundRemoval
};
