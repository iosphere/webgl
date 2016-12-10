module WebGL.Settings
    exposing
        ( Setting
        , blend
        , BlendOptions
        , blendOptions
        , blendSeparate
        , depth
        , DepthOptions
        , depthOptions
        , stencil
        , StencilOptions
        , stencilOptions
        , stencilSeparate
        , scissor
        , colorMask
        , cullFace
        , dither
        , polygonOffset
        , sampleCoverage
        , sampleAlphaToCoverage
        )

{-| The `WebGL.Setting` provides a typesafe way to call
all pre-fragment operations and some special functions.

# Settings

@docs Setting

# Blending

@docs blend, blendSeparate, BlendOptions, blendOptions

# Depth Test

@docs depth, DepthOptions, depthOptions

# Stencil Test

@docs stencil, StencilOptions, stencilOptions, stencilSeparate

# Other settings

@docs scissor, colorMask, cullFace, dither, polygonOffset,
      sampleCoverage, sampleAlphaToCoverage

-}

import WebGL.Constants


{-| To initiate a `Setting` please use one of the following functions
-}
type Setting
    = Blend BlendOptions Float Float Float Float
    | BlendSeparate BlendOptions BlendOptions Float Float Float Float
    | Depth DepthOptions
    | Stencil StencilOptions
    | StencilSeparate StencilOptions StencilOptions
    | Scissor Int Int Int Int
    | ColorMask Bool Bool Bool Bool
    | CullFace Int
    | Dither
    | PolygonOffset Float Float
    | SampleCoverage Float Bool
    | SampleAlphaToCoverage


{-| Blend setting allows to control how the source and destination
colors are blended. Initiate it with BlendOptions and
red green blue alpha color components, that are from 0 to 1.
-}
blend : BlendOptions -> Float -> Float -> Float -> Float -> Setting
blend =
    Blend


{-| Defines options for the blend setting

* `equation` specifies how source and destination color components are combined
* `source` specifies how the source blending factors are computed
* `destination` specifies how the destination blending factors are computed

srcAlphaSaturate should only be used for the source.

constantColor and constantAlpha values should not be used together
as source and destination.

-}
type alias BlendOptions =
    { equation : WebGL.Constants.BlendEquation
    , source : WebGL.Constants.BlendFactor
    , destination : WebGL.Constants.BlendFactor
    }


{-| Defaut options for the blend setting
-}
blendOptions : BlendOptions
blendOptions =
    { equation = WebGL.Constants.add
    , source = WebGL.Constants.one
    , destination = WebGL.Constants.zero
    }


{-| The same as blend setting, but allows to pass separate
blend options for color channels and alpha channel
-}
blendSeparate : BlendOptions -> BlendOptions -> Float -> Float -> Float -> Float -> Setting
blendSeparate =
    BlendSeparate


{-| Activates depth comparisons and updates to the depth buffer.
Initiate it with DepthOptions.
-}
depth : DepthOptions -> Setting
depth =
    Depth


{-| Defines options for the depth setting

* `func` specifies a function that compares incoming pixel depth to the current depth buffer value
* `mask` specifies whether the depth buffer is enabled for writing
* `near` specifies the mapping of the near clipping plane to window coordinates
* `far` specifies the mapping of the far clipping plane to window coordinates
-}
type alias DepthOptions =
    { func : WebGL.Constants.CompareMode
    , mask : Bool
    , near : Float
    , far : Float
    }


{-| Defaut options for the depth setting
-}
depthOptions : DepthOptions
depthOptions =
    { func = WebGL.Constants.less
    , mask = True
    , near = 0
    , far = 1
    }


{-| Activates stencil testing and updates to the stencil buffer.
Initiate it with StencilOptions.
-}
stencil : StencilOptions -> Setting
stencil =
    Stencil


{-| Defines options for the stencil setting

* `func` - the test function
* `ref` - the reference value for the stencil test, clamped to the range 0 to 2^n - 1, n is the number of bitplanes in the stencil buffer
* `valueMask` - bit-wise mask that is used to AND the reference value and the stored stencil value when the test is done
* `fail` - the function to use when the stencil test fails
* `zfail` - the function to use when the stencil test passes, but the depth test fails
* `zpass` - the function to use when both the stencil test and the depth test pass, or when the stencil test passes and there is no depth buffer or depth testing is disabled
* `writeMask` - a bit mask to enable or disable writing of individual bits in the stencil plane
-}
type alias StencilOptions =
    { func : WebGL.Constants.CompareMode
    , ref : Int
    , valueMask : Int
    , fail : WebGL.Constants.ZMode
    , zfail : WebGL.Constants.ZMode
    , zpass : WebGL.Constants.ZMode
    , writeMask : Int
    }


{-| Defaut options for the stencil setting
-}
stencilOptions : StencilOptions
stencilOptions =
    { func = WebGL.Constants.always
    , ref = 0
    , valueMask = 4294967295
    , fail = WebGL.Constants.keep
    , zfail = WebGL.Constants.keep
    , zpass = WebGL.Constants.keep
    , writeMask = 4294967295
    }


{-| separate settings for front- and back-facing polygons
-}
stencilSeparate : StencilOptions -> StencilOptions -> Setting
stencilSeparate =
    StencilSeparate


{-| Set the scissor box, which limits the drawing of fragments to the
screen to a specified rectangle.

The arguments are the coordinates of the lower left corner, width and height.

-}
scissor : Int -> Int -> Int -> Int -> Setting
scissor =
    Scissor


{-| Specify whether or not each channel (red, green, blue, alpha)
should be written into the frame buffer.
-}
colorMask : Bool -> Bool -> Bool -> Bool -> Setting
colorMask =
    ColorMask


{-| Cull polygons based on their winding in window coordinates.

Polygons with counter-clock-wise winding are front-facing .

-}
cullFace : WebGL.Constants.FaceMode -> Setting
cullFace (WebGL.Constants.FaceMode faceMode) =
    CullFace faceMode


{-| Dither color components or indices before they
are written to the color buffer.
-}
dither : Setting
dither =
    Dither


{-| Add an offset to depth values of a polygon's fragments
produced by rasterization. The offset is added before the depth
test is performed and before the value is written into the depth buffer.

* the first argument is the scale factor for the variable depth offset for each polygon.
* the second argument is the multiplier by which an implementation-specific value is multiplied
  with to create a constant depth offset.
-}
polygonOffset : Float -> Float -> Setting
polygonOffset =
    PolygonOffset


{-| Specify multisample coverage parameters.

The fragment's coverage is ANDed with the temporary coverage value.

* the first argument specifies sample coverage value, that is clamped to the range 0 1.
* the second argument represents if the coverage masks should be inverted.
-}
sampleCoverage : Float -> Bool -> Setting
sampleCoverage =
    SampleCoverage


{-| Compute a temporary coverage value
where each bit is determined by the alpha value at the corresponding sample location.

The temporary coverage value is then ANDed with the fragment coverage value.
-}
sampleAlphaToCoverage : Setting
sampleAlphaToCoverage =
    SampleAlphaToCoverage
