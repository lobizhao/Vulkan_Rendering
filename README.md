Vulkan Grass Rendering
==================================
* Tested on: Windows 11 Pro, i5-10600KF @ 4.10GHz 32GB, RTX 3080 10GB

<div align="center">
  <img src="img/headImg.gif">
  <br>
  Overlook
</div>

## Features Implemented

### 1. Grass Blade Representation
- Bezier Curve Model: Each grass blade is represented as a quadratic Bezier curve with three control points (v0, v1, v2)
- Physical Properties: Height, width, orientation, and stiffness coefficient for each blade
- Dynamic Simulation: Blades respond to gravity, recovery forces, and wind in real-time

### 2. Forces Simulation
<div align="center">
  <img src="img/noise.gif" width="500">
  <br>
  <i>Grass procedural wind forces</i>
</div>

#### Gravity Force
- Environmental Gravity: Downward force simulating natural gravity
- Front Gravity: Additional force based on blade orientation to create natural bending
- Combined gravity creates realistic drooping effect

#### Recovery Force
- Restores blade to original upright position based on stiffness coefficient
- Higher stiffness = faster recovery to vertical position
- Simulates the elastic properties of real grass

#### Wind Force
- Procedural Wind Field: Multi-octave noise-based wind simulation
- Spatial Variation: Different wind strength across the field using hash-based noise
- Temporal Animation: Wind direction rotates over time with turbulence
- Wind Alignment: Blades bend more when wind direction aligns with blade orientation
- Height-based Effect: Wind affects blade tips more than roots

### 3. Culling Optimizations
<div align="center">
  <img src="img/culling.gif" width="500">
  <br>
  <i>Distance Culling</i>
</div>

<div align="center">
  <img src="img/view.gif" width="500">
  <br>
  <i>View Frustum</i>
</div>

Implemented three types of culling to dramatically improve performance:

InitializeWindow(1080, 768)

NUM_BLADES 1^15
<div align="center">
  <img src="img/Culling Type.png">
  <br>
  <i>Culling type comparsion</i>
</div>

#### Orientation Culling
- Culls grass blades that are nearly parallel to the view direction
- Removes blades that appear as thin lines from the camera's perspective
- Threshold: `dot(bladeDirection, viewDirection) > 0.9`

#### View-Frustum Culling
- Culls blades outside the camera's view frustum
- Tests three points per blade: root (v0), tip (v2), and midpoint (m)
- Only renders blades visible on screen

#### Distance Culling with LOD
- Culls blades beyond maximum distance (30 units)
- Progressive culling: farther blades have higher probability of being culled
- 10 distance buckets for gradual density reduction

### 4. Blade Count Performance Analysis
InitializeWindow(1080, 768)
<div align="center">
  <img src="img/NUM_BLADES base Run FPS.png">
  <br>
  <i>FPS vs Number of Grass Blades</i>
</div>

**Analysis:**
- The system maintains excellent performance (>1000 FPS) up to 32,768 blades
- Performance degrades approximately linearly with blade count in log scale
- At 2^17 (131K blades), FPS drops to ~540, still maintaining real-time performance
- Beyond 1 million blades (2^20), performance becomes impractical for real-time applications
- The RTX 3080 can handle up to ~500K blades while maintaining playable framerates (>60 FPS)

### 4. Extra Credit - Tessellation-based LOD
<div align="center">
  <img src="img/Lod.gif" width="500">
  <br>
  <i>Tessellation LOD</i>
</div>

- Dynamic tessellation level based on distance to camera
- Near Distance: 5 vertical segments, 7 horizontal segments (35 vertices)
- Far Distance: 1 vertical segment, 3 horizontal segments (3 vertices)
- Middle Range: Linear interpolation between near and far


