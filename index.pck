GDPC                                                                               @   res://.import/Sprites.png-a317c0d02d22df072599e910902eab4d.stex ?K      ?      ?jI?o??y??h?1RH   res://.import/TilesetMinimal.png-13a73f33b98ac6c8cd1eaa21812f3c34.stex  PP      (      ?&w???b?^???X0ѣ<   res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex??      ?      &?y???ڞu;>??.p,   res://Resources/Shaders/crt_material.tres   `      (      ?u?o!=+K ?.J?q,   res://Resources/Shaders/crt_shader.shader   ?
      ?      GU;خ?B??`??K?R$<   res://Resources/Shaders/vhs-and-crt-monitor-effect.shader          6)      ?s+?QB?Ľ??幯?8   res://Resources/Shaders/vhs-and-crt-monitor-effect.tres `?      ?      ??(J?ѭ?#??n?$   res://Resources/Sprites/Fire.tres   ?B            ?k;l?l?"62 ?4$   res://Resources/Sprites/Knight.tres  G      K      ?f??h?U???MZ$   res://Resources/Sprites/Zombie.tres PI      N      ???aSiڢI??:'?,   res://Resources/Textures/Sprites.png.import ?M      ?      ??ޤ??q?);?4   res://Resources/Textures/TilesetMinimal.png.import  ?Q      ?      ??䊰??r?~8??   res://Resources/Tileset.tres`T      ]      ?qIDa????????   res://Scenes/MainScene.tscn ?d      ?@      ????-??B?-?b?Q?    res://Scenes/Sprites/Archer.tscn`?      ?      f?pF?????ΰ[??J    res://Scenes/Sprites/Fire.tscn  @?      	      N҅?)$? ;?s??]N    res://Scenes/Sprites/Knight.tscnP?            ???L????8?bO/^Ұ    res://Scenes/Sprites/Zombie.tscn`?            y'C?Z95??3~J??u    res://Scripts/camera.gd.remap   P?      )       ?I?hb?R??jA?   res://Scripts/camera.gdcp?      ?      w?v??????\-??F?k   res://default_env.tres  ?      ?       um?`?N??<*ỳ?8   res://icon.png  ??      ?      G1???z?c??vN???   res://icon.png.import   ??      ?      ??fe??6?B??^ U?   res://project.binaryp?      ?      ?L,z:?Z???Y?)$?         [gd_resource type="ShaderMaterial" load_steps=2 format=2]

[ext_resource path="res://Resources/Shaders/crt_shader.shader" type="Shader" id=1]

[resource]
shader = ExtResource( 1 )
shader_param/screen_size = Vector2( 1024, 768 )
shader_param/show_curvature = false
shader_param/curvature_x_amount = 6.0
shader_param/curvature_y_amount = 4.0
shader_param/corner_color = Color( 0, 0, 0, 1 )
shader_param/show_vignette = true
shader_param/vignette_opacity = 0.2
shader_param/show_horizontal_scan_lines = true
shader_param/horizontal_scan_lines_amount = 180.0
shader_param/horizontal_scan_lines_opacity = 1.0
shader_param/show_vertical_scan_lines = false
shader_param/vertical_scan_lines_amount = 320.0
shader_param/vertical_scan_lines_opacity = 1.0
shader_param/boost = 1.2
shader_param/aberration_amount = 1.27
        /*
Godot 3 2D CRT Shader.
A 2D shader for Godot 3 simulating a CRT..

Author: hiulit
Repository: https://github.com/hiulit/Godot-3-2D-CRT-Shader
Issues: https://github.com/hiulit/Godot-3-2D-CRT-Shader/issues
License: MIT https://github.com/hiulit/Godot-3-2D-CRT-Shader/blob/master/LICENSE
*/

shader_type canvas_item;

const float PI = 3.14159265359;

uniform vec2 screen_size = vec2(320.0, 180.0);
uniform bool show_curvature = true;
uniform float curvature_x_amount : hint_range(3.0, 15.0, 0.01) = float(6.0); 
uniform float curvature_y_amount : hint_range(3.0, 15.0, 0.01) = float(4.0);
uniform vec4 corner_color : hint_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform bool show_vignette = true;
uniform float vignette_opacity : hint_range(0.0, 1.0, 0.01) = 0.2;
uniform bool show_horizontal_scan_lines = true;
uniform float horizontal_scan_lines_amount : hint_range(0.0, 180.0, 0.1) = 180.0;
uniform float horizontal_scan_lines_opacity : hint_range(0.0, 1.0, 0.01) = 1.0;
uniform bool show_vertical_scan_lines = false;
uniform float vertical_scan_lines_amount : hint_range(0.0, 320.0, 0.1) = 320.0;
uniform float vertical_scan_lines_opacity : hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float boost : hint_range(1.0, 2.0, 0.01) = 1.2;
uniform float aberration_amount : hint_range(0.0, 10.0, 0.01) = 0.0;

vec2 uv_curve(vec2 uv) {
	if (show_curvature) {
		uv = uv * 2.0 - 1.0;
		vec2 offset = abs(uv.yx) / vec2(curvature_x_amount, curvature_y_amount);
		uv = uv + uv * offset * offset;
		uv = uv * 0.5 + 0.5;
	}

	return uv;
}


void fragment() {
	vec2 uv = uv_curve(UV);
	vec2 screen_uv = uv_curve(SCREEN_UV);
	vec3 color = texture(SCREEN_TEXTURE, screen_uv).rgb;

	if (aberration_amount > 0.0) {
		float adjusted_amount = aberration_amount / screen_size.x;
		color.r = texture(SCREEN_TEXTURE, vec2(screen_uv.x + adjusted_amount, screen_uv.y)).r;
		color.g = texture(SCREEN_TEXTURE, screen_uv).g;
		color.b = texture(SCREEN_TEXTURE, vec2(screen_uv.x - adjusted_amount, screen_uv.y)).b;
	}

	if (show_vignette) {
		float vignette = uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y);
		vignette = clamp(pow((screen_size.x / 4.0) * vignette, vignette_opacity), 0.0, 1.0);
		color *= vignette;
	}

	if (show_horizontal_scan_lines) {
		float s = sin(screen_uv.y * horizontal_scan_lines_amount * PI * 2.0);
		s = (s * 0.5 + 0.5) * 0.9 + 0.1;
		vec4 scan_line = vec4(vec3(pow(s, horizontal_scan_lines_opacity)), 1.0);
		color *= scan_line.rgb;
	}

	if (show_vertical_scan_lines) {
		float s = sin(screen_uv.x * vertical_scan_lines_amount * PI * 2.0);
		s = (s * 0.5 + 0.5) * 0.9 + 0.1;
		vec4 scan_line = vec4(vec3(pow(s, vertical_scan_lines_opacity)), 1.0);
		color *= scan_line.rgb;
	}

	if (show_horizontal_scan_lines || show_vertical_scan_lines) {
		color *= boost;
	}

	// Fill the blank space of the corners, left by the curvature, with black.
	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
		color = corner_color.rgb;
	}

	COLOR = vec4(color, 1.0);
}
        /*
Shader from Godot Shaders - the free shader library.
godotshaders.com/shader/VHS-and-CRT-monitor-effect

This shader is under CC0 license. Feel free to use, improve and 
change this shader according to your needs and consider sharing 
the modified result to godotshaders.com.
*/

shader_type canvas_item;

//*** IMPORTANT! ***/ 
// - If you are using this shader to affect the node it is applied to set 'overlay' to false (unchecked in the instepctor).
// - If you are using this shader as an overlay, and want the shader to affect the nodes below in the Scene hierarchy,
//   set 'overlay' to true (checked in the inspector).
// On Mac there is potentially a bug causing this to not work properly. If that is the case and you want to use the shader as an overlay
// change all "overlay ? SCREEN_TEXTURE : TEXTURE" to only "SCREEN_TEXTURE" on lines 129-140, and "vec2 uv = overlay ? warp(SCREEN_UV) : warp(UV);"
// to "vec2 uv = warp(SCREEN_UV);" on line 98.
uniform bool overlay = false;

uniform float scanlines_opacity : hint_range(0.0, 1.0) = 0.4;
uniform float scanlines_width : hint_range(0.0, 0.5) = 0.25;
uniform float grille_opacity : hint_range(0.0, 1.0) = 0.3;
uniform vec2 resolution = vec2(640.0, 480.0); // Set the number of rows and columns the texture will be divided in. Scanlines and grille will make a square based on these values

uniform bool pixelate = true; // Fill each square ("pixel") with a sampled color, creating a pixel look and a more accurate representation of how a CRT monitor would work.

uniform bool roll = true;
uniform float roll_speed = 8.0; // Positive values are down, negative are up
uniform float roll_size : hint_range(0.0, 100.0) = 15.0;
uniform float roll_variation : hint_range(0.1, 5.0) = 1.8; // This valie is not an exact science. You have to play around with the value to find a look you like. How this works is explained in the code below.
uniform float distort_intensity : hint_range(0.0, 0.2) = 0.05; // The distortion created by the rolling effect.

uniform float noise_opacity : hint_range(0.0, 1.0) = 0.4;
uniform float noise_speed = 5.0; // There is a movement in the noise pattern that can be hard to see first. This sets the speed of that movement.

uniform float static_noise_intensity : hint_range(0.0, 1.0) = 0.06;

uniform float aberration : hint_range(-1.0, 1.0) = 0.03; // Chromatic aberration, a distortion on each color channel.
uniform float brightness = 1.4; // When adding scanline gaps and grille the image can get very dark. Brightness tries to compensate for that.
uniform bool discolor = true; // Add a discolor effect simulating a VHS

uniform float warp_amount :hint_range(0.0, 5.0) = 1.0; // Warp the texture edges simulating the curved glass of a CRT monitor or old TV.
uniform bool clip_warp = false;

uniform float vignette_intensity = 0.4; // Size of the vignette, how far towards the middle it should go.
uniform float vignette_opacity : hint_range(0.0, 1.0) = 0.5;

// Used by the noise functin to generate a pseudo random value between 0.0 and 1.0
vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

// Generate a Perlin noise used by the distortion effects
float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix( mix( dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
                mix( dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) * 0.5 + 0.5;
}

// Takes in the UV and warps the edges, creating the spherized effect
vec2 warp(vec2 uv){
	vec2 delta = uv - 0.5;
	float delta2 = dot(delta.xy, delta.xy);
	float delta4 = delta2 * delta2;
	float delta_offset = delta4 * warp_amount;
	
	return uv + delta * delta_offset;
}

// Adds a black border to hide stretched pixel created by the warp effect
float border (vec2 uv){
	float radius = min(warp_amount, 0.08);
	radius = max(min(min(abs(radius * 2.0), abs(1.0)), abs(1.0)), 1e-5);
	vec2 abs_uv = abs(uv * 2.0 - 1.0) - vec2(1.0, 1.0) + radius;
	float dist = length(max(vec2(0.0), abs_uv)) / radius;
	float square = smoothstep(0.96, 1.0, dist);
	return clamp(1.0 - square, 0.0, 1.0);
}

// Adds a vignette shadow to the edges of the image
float vignette(vec2 uv){
	uv *= 1.0 - uv.xy;
	float vignette = uv.x * uv.y * 15.0;
	return pow(vignette, vignette_intensity * vignette_opacity);
}

void fragment()
{
	vec2 uv = overlay ? warp(SCREEN_UV) : warp(UV); // Warp the uv. uv will be used in most cases instead of UV to keep the warping
	vec2 text_uv = uv;
	vec2 roll_uv = vec2(0.0);
	float time = roll ? TIME : 0.0;
	

	// Pixelate the texture based on the given resolution.
	if (pixelate)
	{
		text_uv = ceil(uv * resolution) / resolution;
	}
	
	// Create the rolling effect. We need roll_line a bit later to make the noise effect.
	// That is why this runs if roll is true OR noise_opacity is over 0.
	float roll_line = 0.0;
	if (roll || noise_opacity > 0.0)
	{
		// Create the areas/lines where the texture will be distorted.
		roll_line = smoothstep(0.3, 0.9, sin(uv.y * roll_size - (time * roll_speed) ) );
		// Create more lines of a different size and apply to the first set of lines. This creates a bit of variation.
		roll_line *= roll_line * smoothstep(0.3, 0.9, sin(uv.y * roll_size * roll_variation - (time * roll_speed * roll_variation) ) );
		// Distort the UV where where the lines are
		roll_uv = vec2(( roll_line * distort_intensity * (1.-UV.x)), 0.0);
	}
	
	vec4 text;
	if (roll)
	{
		// If roll is true distort the texture with roll_uv. The texture is split up into RGB to 
		// make some chromatic aberration. We apply the aberration to the red and green channels accorging to the aberration parameter
		// and intensify it a bit in the roll distortion.
		text.r = texture(SCREEN_TEXTURE, text_uv + roll_uv * 0.8 + vec2(aberration, 0.0) * .1).r;
		text.g = texture(SCREEN_TEXTURE, text_uv + roll_uv * 1.2 - vec2(aberration, 0.0) * .1 ).g;
		text.b = texture(SCREEN_TEXTURE, text_uv + roll_uv).b;
		text.a = 1.0;
	}
	else
	{
		// If roll is false only apply the aberration without any distorion. The aberration values are very small so the .1 is only 
		// to make the slider in the Inspector less sensitive.
		text.r = texture(SCREEN_TEXTURE, text_uv + vec2(aberration, 0.0) * .1).r;
		text.g = texture(SCREEN_TEXTURE, text_uv - vec2(aberration, 0.0) * .1).g;
		text.b = texture(SCREEN_TEXTURE, text_uv).b;
		text.a = 1.0;
	}
	
	float r = text.r;
	float g = text.g;
	float b = text.b;
	
	uv = warp(UV);
	
	// CRT monitors don't have pixels but groups of red, green and blue dots or lines, called grille. We isolate the texture's color channels 
	// and divide it up in 3 offsetted lines to show the red, green and blue colors next to each other, with a small black gap between.
	if (grille_opacity > 0.0){
		
		float g_r = smoothstep(0.85, 0.95, abs(sin(uv.x * (resolution.x * 3.14159265))));
		r = mix(r, r * g_r, grille_opacity);
		
		float g_g = smoothstep(0.85, 0.95, abs(sin(1.05 + uv.x * (resolution.x * 3.14159265))));
		g = mix(g, g * g_g, grille_opacity);
		
		float b_b = smoothstep(0.85, 0.95, abs(sin(2.1 + uv.x * (resolution.x * 3.14159265))));
		b = mix(b, b * b_b, grille_opacity);
		
	}
	
	// Apply the grille to the texture's color channels and apply Brightness. Since the grille and the scanlines (below) make the image very dark you
	// can compensate by increasing the brightness.
	text.r = clamp(r * brightness, 0.0, 1.0);
	text.g = clamp(g * brightness, 0.0, 1.0);
	text.b = clamp(b * brightness, 0.0, 1.0);
	
	// Scanlines are the horizontal lines that make up the image on a CRT monitor. 
	// Here we are actual setting the black gap between each line, which I guess is not the right definition of the word, but you get the idea  
	float scanlines = 0.5;
	if (scanlines_opacity > 0.0)
	{
		// Same technique as above, create lines with sine and applying it to the texture. Smoothstep to allow setting the line size.
		scanlines = smoothstep(scanlines_width, scanlines_width + 0.5, abs(sin(uv.y * (resolution.y * 3.14159265))));
		text.rgb = mix(text.rgb, text.rgb * vec3(scanlines), scanlines_opacity);
	}
	
	// Apply the banded noise.
	if (noise_opacity > 0.0)
	{
		// Generate a noise pattern that is very stretched horizontally, and animate it with noise_speed
		float noise = smoothstep(0.4, 0.5, noise(uv * vec2(2.0, 200.0) + vec2(10.0, (TIME * (noise_speed))) ) );
		
		// We use roll_line (set above) to define how big the noise should be vertically (multiplying cuts off all black parts).
		// We also add in some basic noise with random() to break up the noise pattern above. The noise is sized according to 
		// the resolution value set in the inspector. If you don't like this look you can 
		// change "ceil(uv * resolution) / resolution" to only "uv" to make it less pixelated. Or multiply resolution with som value
		// greater than 1.0 to make them smaller.
		roll_line *= noise * scanlines * clamp(random((ceil(uv * resolution) / resolution) + vec2(TIME * 0.8, 0.0)).x + 0.8, 0.0, 1.0);
		// Add it to the texture based on noise_opacity
		text.rgb = clamp(mix(text.rgb, text.rgb + roll_line, noise_opacity), vec3(0.0), vec3(1.0));
	}
	
	// Apply static noise by generating it over the whole screen in the same way as above
	if (static_noise_intensity > 0.0)
	{
		text.rgb += clamp(random((ceil(uv * resolution) / resolution) + fract(TIME)).x, 0.0, 1.0) * static_noise_intensity;
	}
	
	// Apply a black border to hide imperfections caused by the warping.
	// Also apply the vignette
	text.rgb *= border(uv);
	text.rgb *= vignette(uv);
	// Hides the black border and make that area transparent. Good if you want to add the the texture on top an image of a TV or monitor.
	if (clip_warp)
	{
		text.a = border(uv);
	}
	
	// Apply discoloration to get a VHS look (lower saturation and higher contrast)
	// You can play with the values below or expose them in the Inspector.
	float saturation = 0.5;
	float contrast = 1.2;
	if (discolor)
	{
		// Saturation
		vec3 greyscale = vec3(text.r + text.g + text.b) / 3.;
		text.rgb = mix(text.rgb, greyscale, saturation);
		
		// Contrast
		float midpoint = pow(0.5, 2.2);
		text.rgb = (text.rgb - vec3(midpoint)) * contrast + midpoint;
	}
	
	COLOR = text;
}
          [gd_resource type="ShaderMaterial" load_steps=2 format=2]

[ext_resource path="res://Resources/Shaders/vhs-and-crt-monitor-effect.shader" type="Shader" id=1]

[resource]
shader = ExtResource( 1 )
shader_param/overlay = true
shader_param/scanlines_opacity = 0.314
shader_param/scanlines_width = 0.093
shader_param/grille_opacity = 0.18
shader_param/resolution = Vector2( 128, 96 )
shader_param/pixelate = false
shader_param/roll = false
shader_param/roll_speed = 60.0
shader_param/roll_size = 0.98
shader_param/roll_variation = 0.79
shader_param/distort_intensity = 0.005
shader_param/noise_opacity = 0.018
shader_param/noise_speed = 5.0
shader_param/static_noise_intensity = 0.02
shader_param/aberration = 0.0
shader_param/brightness = 0.8
shader_param/discolor = false
shader_param/warp_amount = 0.0
shader_param/clip_warp = false
shader_param/vignette_intensity = 0.4
shader_param/vignette_opacity = 0.5
      [gd_resource type="SpriteFrames" load_steps=9 format=2]

[ext_resource path="res://Resources/Textures/Sprites.png" type="Texture" id=1]

[sub_resource type="AtlasTexture" id=1]
atlas = ExtResource( 1 )
region = Rect2( 0, 40, 8, 8 )

[sub_resource type="AtlasTexture" id=2]
atlas = ExtResource( 1 )
region = Rect2( 8, 40, 8, 8 )

[sub_resource type="AtlasTexture" id=3]
atlas = ExtResource( 1 )
region = Rect2( 16, 40, 8, 8 )

[sub_resource type="AtlasTexture" id=4]
atlas = ExtResource( 1 )
region = Rect2( 24, 40, 8, 8 )

[sub_resource type="AtlasTexture" id=5]
atlas = ExtResource( 1 )
region = Rect2( 32, 40, 8, 8 )

[sub_resource type="AtlasTexture" id=6]
atlas = ExtResource( 1 )
region = Rect2( 40, 40, 8, 8 )

[sub_resource type="AtlasTexture" id=7]
atlas = ExtResource( 1 )
region = Rect2( 48, 40, 8, 8 )

[resource]
animations = [ {
"frames": [ SubResource( 1 ), SubResource( 2 ), SubResource( 3 ), SubResource( 4 ), SubResource( 5 ), SubResource( 6 ), SubResource( 7 ) ],
"loop": true,
"name": "default",
"speed": 5.0
} ]
        [gd_resource type="SpriteFrames" load_steps=5 format=2]

[ext_resource path="res://Resources/Textures/Sprites.png" type="Texture" id=1]

[sub_resource type="AtlasTexture" id=1]
atlas = ExtResource( 1 )
region = Rect2( 0, 0, 8, 8 )

[sub_resource type="AtlasTexture" id=2]
atlas = ExtResource( 1 )
region = Rect2( 8, 0, 8, 8 )

[sub_resource type="AtlasTexture" id=3]
atlas = ExtResource( 1 )
region = Rect2( 16, 0, 8, 8 )

[resource]
animations = [ {
"frames": [ SubResource( 1 ), SubResource( 2 ), SubResource( 3 ), SubResource( 2 ) ],
"loop": true,
"name": "default",
"speed": 2.0
} ]
     [gd_resource type="SpriteFrames" load_steps=5 format=2]

[ext_resource path="res://Resources/Textures/Sprites.png" type="Texture" id=1]

[sub_resource type="AtlasTexture" id=1]
atlas = ExtResource( 1 )
region = Rect2( 0, 16, 8, 8 )

[sub_resource type="AtlasTexture" id=2]
atlas = ExtResource( 1 )
region = Rect2( 8, 16, 8, 8 )

[sub_resource type="AtlasTexture" id=3]
atlas = ExtResource( 1 )
region = Rect2( 16, 16, 8, 8 )

[resource]
animations = [ {
"frames": [ SubResource( 1 ), SubResource( 2 ), SubResource( 3 ), SubResource( 2 ) ],
"loop": true,
"name": "default",
"speed": 2.0
} ]
  GDST?   ?             ?  WEBPRIFF?  WEBPVP8L?  /?'  I????@ ɟr?I6?. (???? HlI??Y?8ց?XT??T????#???w-^?X?6??XƂ]K??]??	???HF???[X??X&h@
?ǎ??#?]?,dy?X?D6????x~?K`??k?? ?,C8?̳71?<??/w1ڄ?/'??er?@ AH2? ???4`p6?$?x?$??$b??M `?`s?D/ҙ@F???`apr"?m?8?????{։A ?X?C?@"D?(??K?(???	?=?[?Vb?Da?1 N??
Y@'Ȉ??R$?s??܀?ᯜ^?6?[?[??}????qu?j?jG??v?v?v??/??1????j?l???=??v???Z?X?l??c??1ڹڱ?9?ƺ?:?v??5?1?9?u?qX?\?l;V;V;os???????     [remap]

importer="texture"
type="StreamTexture"
path="res://.import/Sprites.png-a317c0d02d22df072599e910902eab4d.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://Resources/Textures/Sprites.png"
dest_files=[ "res://.import/Sprites.png-a317c0d02d22df072599e910902eab4d.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=false
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=false
svg/scale=1.0
GDST?   ?               WEBPRIFF   WEBPVP8L?   /?g`?m?J9x?????f???T?O??{???+d$I*?ex1????B@P??h?·??Z?{ G??F?7?4@lV?܂Ϝp$???~??F_WN3|?CD?'@$ϳ,;O????'???????g?[?c??a?? ?p?9??Y???$?$?7??Sм????,h<<T5?jT?H?
DTF?ã?3?"?@$?G?ϧZ???????@??i???-??6v??ۺ???l?W?????        [remap]

importer="texture"
type="StreamTexture"
path="res://.import/TilesetMinimal.png-13a73f33b98ac6c8cd1eaa21812f3c34.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://Resources/Textures/TilesetMinimal.png"
dest_files=[ "res://.import/TilesetMinimal.png-13a73f33b98ac6c8cd1eaa21812f3c34.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=false
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=false
svg/scale=1.0
           [gd_resource type="TileSet" load_steps=2 format=2]

[ext_resource path="res://Resources/Textures/TilesetMinimal.png" type="Texture" id=1]

[resource]
0/name = "Empty"
0/texture = ExtResource( 1 )
0/tex_offset = Vector2( 0, 0 )
0/modulate = Color( 1, 1, 1, 1 )
0/region = Rect2( 0, 0, 8, 8 )
0/tile_mode = 0
0/occluder_offset = Vector2( 0, 0 )
0/navigation_offset = Vector2( 0, 0 )
0/shape_offset = Vector2( 0, 0 )
0/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
0/shape_one_way = false
0/shape_one_way_margin = 0.0
0/shapes = [  ]
0/z_index = 0
1/name = "StoneWall"
1/texture = ExtResource( 1 )
1/tex_offset = Vector2( 0, 0 )
1/modulate = Color( 1, 1, 1, 1 )
1/region = Rect2( 8, 0, 8, 8 )
1/tile_mode = 0
1/occluder_offset = Vector2( 0, 0 )
1/navigation_offset = Vector2( 0, 0 )
1/shape_offset = Vector2( 0, 0 )
1/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
1/shape_one_way = false
1/shape_one_way_margin = 0.0
1/shapes = [  ]
1/z_index = 0
2/name = "DirtWall"
2/texture = ExtResource( 1 )
2/tex_offset = Vector2( 0, 0 )
2/modulate = Color( 1, 1, 1, 1 )
2/region = Rect2( 16, 0, 8, 8 )
2/tile_mode = 0
2/occluder_offset = Vector2( 0, 0 )
2/navigation_offset = Vector2( 0, 0 )
2/shape_offset = Vector2( 0, 0 )
2/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
2/shape_one_way = false
2/shape_one_way_margin = 0.0
2/shapes = [  ]
2/z_index = 0
3/name = "Entrance"
3/texture = ExtResource( 1 )
3/tex_offset = Vector2( 0, 0 )
3/modulate = Color( 1, 1, 1, 1 )
3/region = Rect2( 0, 8, 8, 8 )
3/tile_mode = 0
3/occluder_offset = Vector2( 0, 0 )
3/navigation_offset = Vector2( 0, 0 )
3/shape_offset = Vector2( 0, 0 )
3/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
3/shape_one_way = false
3/shape_one_way_margin = 0.0
3/shapes = [  ]
3/z_index = 0
4/name = "MetalBars"
4/texture = ExtResource( 1 )
4/tex_offset = Vector2( 0, 0 )
4/modulate = Color( 1, 1, 1, 1 )
4/region = Rect2( 8, 8, 8, 8 )
4/tile_mode = 0
4/occluder_offset = Vector2( 0, 0 )
4/navigation_offset = Vector2( 0, 0 )
4/shape_offset = Vector2( 0, 0 )
4/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
4/shape_one_way = false
4/shape_one_way_margin = 0.0
4/shapes = [  ]
4/z_index = 0
5/name = "Ladders"
5/texture = ExtResource( 1 )
5/tex_offset = Vector2( 0, 0 )
5/modulate = Color( 1, 1, 1, 1 )
5/region = Rect2( 0, 16, 8, 8 )
5/tile_mode = 0
5/occluder_offset = Vector2( 0, 0 )
5/navigation_offset = Vector2( 0, 0 )
5/shape_offset = Vector2( 0, 0 )
5/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
5/shape_one_way = false
5/shape_one_way_margin = 0.0
5/shapes = [  ]
5/z_index = 0
6/name = "PlatformLeft"
6/texture = ExtResource( 1 )
6/tex_offset = Vector2( 0, 0 )
6/modulate = Color( 1, 1, 1, 1 )
6/region = Rect2( 8, 16, 8, 8 )
6/tile_mode = 0
6/occluder_offset = Vector2( 0, 0 )
6/navigation_offset = Vector2( 0, 0 )
6/shape_offset = Vector2( 0, 0 )
6/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
6/shape_one_way = false
6/shape_one_way_margin = 0.0
6/shapes = [  ]
6/z_index = 0
7/name = "PlatformMiddle"
7/texture = ExtResource( 1 )
7/tex_offset = Vector2( 0, 0 )
7/modulate = Color( 1, 1, 1, 1 )
7/region = Rect2( 16, 16, 8, 8 )
7/tile_mode = 0
7/occluder_offset = Vector2( 0, 0 )
7/navigation_offset = Vector2( 0, 0 )
7/shape_offset = Vector2( 0, 0 )
7/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
7/shape_one_way = false
7/shape_one_way_margin = 0.0
7/shapes = [  ]
7/z_index = 0
8/name = "PlatformRight"
8/texture = ExtResource( 1 )
8/tex_offset = Vector2( 0, 0 )
8/modulate = Color( 1, 1, 1, 1 )
8/region = Rect2( 24, 16, 8, 8 )
8/tile_mode = 0
8/occluder_offset = Vector2( 0, 0 )
8/navigation_offset = Vector2( 0, 0 )
8/shape_offset = Vector2( 0, 0 )
8/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
8/shape_one_way = false
8/shape_one_way_margin = 0.0
8/shapes = [  ]
8/z_index = 0
9/name = "Spikes"
9/texture = ExtResource( 1 )
9/tex_offset = Vector2( 0, 0 )
9/modulate = Color( 1, 1, 1, 1 )
9/region = Rect2( 0, 24, 8, 8 )
9/tile_mode = 0
9/occluder_offset = Vector2( 0, 0 )
9/navigation_offset = Vector2( 0, 0 )
9/shape_offset = Vector2( 0, 0 )
9/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
9/shape_one_way = false
9/shape_one_way_margin = 0.0
9/shapes = [  ]
9/z_index = 0
   [gd_scene load_steps=8 format=2]

[ext_resource path="res://Resources/Tileset.tres" type="TileSet" id=1]
[ext_resource path="res://Scenes/Sprites/Knight.tscn" type="PackedScene" id=2]
[ext_resource path="res://Resources/Shaders/vhs-and-crt-monitor-effect.tres" type="Material" id=3]
[ext_resource path="res://Scenes/Sprites/Fire.tscn" type="PackedScene" id=4]
[ext_resource path="res://Scenes/Sprites/Zombie.tscn" type="PackedScene" id=6]
[ext_resource path="res://Scenes/Sprites/Archer.tscn" type="PackedScene" id=7]

[sub_resource type="Environment" id=1]
background_mode = 4
tonemap_mode = 2
glow_enabled = true
glow_intensity = 2.11
glow_strength = 0.93
glow_bloom = 0.17
glow_blend_mode = 0
adjustment_enabled = true

[node name="Node2D" type="Node2D"]

[node name="CanvasLayer" type="CanvasLayer" parent="."]

[node name="VHSAndCRTMonitorEffect" type="ColorRect" parent="CanvasLayer"]
material = ExtResource( 3 )
margin_right = 1024.0
margin_bottom = 768.0
__meta__ = {
"_edit_use_anchors_": false
}

[node name="WorldEnvironment" type="WorldEnvironment" parent="."]
environment = SubResource( 1 )

[node name="Background" type="TileMap" parent="."]
tile_set = ExtResource( 1 )
cell_size = Vector2( 8, 8 )
format = 1
tile_data = PoolIntArray( 0, 0, 0, 1, 0, 0, 2, 0, 0, 3, 0, 0, 4, 0, 0, 5, 0, 0, 6, 0, 0, 7, 0, 0, 8, 0, 0, 9, 0, 0, 10, 0, 0, 11, 0, 0, 12, 0, 0, 13, 0, 0, 14, 0, 0, 15, 0, 0, 16, 0, 0, 17, 0, 0, 18, 0, 0, 19, 0, 0, 20, 0, 0, 21, 0, 0, 22, 0, 0, 23, 0, 0, 24, 0, 0, 25, 0, 0, 26, 0, 0, 27, 0, 0, 28, 0, 0, 29, 0, 0, 30, 0, 0, 31, 0, 0, 65536, 0, 0, 65537, 0, 0, 65538, 0, 0, 65539, 0, 0, 65540, 0, 0, 65541, 0, 0, 65542, 0, 0, 65543, 0, 0, 65544, 0, 0, 65545, 0, 0, 65546, 0, 0, 65547, 0, 0, 65548, 0, 0, 65549, 0, 0, 65550, 0, 0, 65551, 0, 0, 65552, 0, 0, 65553, 0, 0, 65554, 0, 0, 65555, 0, 0, 65556, 0, 0, 65557, 0, 0, 65558, 0, 0, 65559, 0, 0, 65560, 0, 0, 65561, 0, 0, 65562, 0, 0, 65563, 0, 0, 65564, 0, 0, 65565, 0, 0, 65566, 0, 0, 65567, 0, 0, 131072, 0, 0, 131073, 0, 0, 131074, 0, 0, 131075, 0, 0, 131076, 0, 0, 131077, 0, 0, 131078, 0, 0, 131079, 0, 0, 131080, 0, 0, 131081, 0, 0, 131082, 0, 0, 131083, 0, 0, 131084, 0, 0, 131085, 0, 0, 131086, 0, 0, 131087, 0, 0, 131088, 0, 0, 131089, 0, 0, 131090, 0, 0, 131091, 0, 0, 131092, 0, 0, 131093, 0, 0, 131094, 0, 0, 131095, 0, 0, 131096, 0, 0, 131097, 0, 0, 131098, 0, 0, 131099, 0, 0, 131100, 0, 0, 131101, 0, 0, 131102, 0, 0, 131103, 0, 0, 196608, 0, 0, 196609, 0, 0, 196610, 0, 0, 196611, 0, 0, 196612, 0, 0, 196613, 0, 0, 196614, 0, 0, 196615, 0, 0, 196616, 0, 0, 196617, 0, 0, 196618, 0, 0, 196619, 0, 0, 196620, 0, 0, 196621, 0, 0, 196622, 0, 0, 196623, 0, 0, 196624, 0, 0, 196625, 0, 0, 196626, 0, 0, 196627, 0, 0, 196628, 0, 0, 196629, 0, 0, 196630, 0, 0, 196631, 0, 0, 196632, 0, 0, 196633, 0, 0, 196634, 0, 0, 196635, 0, 0, 196636, 0, 0, 196637, 0, 0, 196638, 0, 0, 196639, 0, 0, 262144, 0, 0, 262145, 0, 0, 262146, 0, 0, 262147, 0, 0, 262148, 0, 0, 262149, 0, 0, 262150, 0, 0, 262151, 0, 0, 262152, 0, 0, 262153, 0, 0, 262154, 0, 0, 262155, 0, 0, 262156, 0, 0, 262157, 0, 0, 262158, 0, 0, 262159, 0, 0, 262160, 0, 0, 262161, 0, 0, 262162, 0, 0, 262163, 0, 0, 262164, 0, 0, 262165, 0, 0, 262166, 0, 0, 262167, 0, 0, 262168, 0, 0, 262169, 0, 0, 262170, 0, 0, 262171, 0, 0, 262172, 0, 0, 262173, 0, 0, 262174, 0, 0, 262175, 0, 0, 327680, 0, 0, 327681, 0, 0, 327682, 0, 0, 327683, 0, 0, 327684, 0, 0, 327685, 0, 0, 327686, 0, 0, 327687, 0, 0, 327688, 0, 0, 327689, 0, 0, 327690, 0, 0, 327691, 0, 0, 327692, 0, 0, 327693, 0, 0, 327694, 0, 0, 327695, 0, 0, 327696, 0, 0, 327697, 0, 0, 327698, 0, 0, 327699, 0, 0, 327700, 0, 0, 327701, 0, 0, 327702, 0, 0, 327703, 0, 0, 327704, 0, 0, 327705, 0, 0, 327706, 0, 0, 327707, 0, 0, 327708, 0, 0, 327709, 0, 0, 327710, 0, 0, 327711, 0, 0, 393216, 0, 0, 393217, 0, 0, 393218, 0, 0, 393219, 0, 0, 393220, 0, 0, 393221, 0, 0, 393222, 0, 0, 393223, 0, 0, 393224, 0, 0, 393225, 0, 0, 393226, 0, 0, 393227, 0, 0, 393228, 0, 0, 393229, 0, 0, 393230, 0, 0, 393231, 0, 0, 393232, 0, 0, 393233, 0, 0, 393234, 0, 0, 393235, 0, 0, 393236, 0, 0, 393237, 0, 0, 393238, 0, 0, 393239, 0, 0, 393240, 0, 0, 393241, 0, 0, 393242, 0, 0, 393243, 0, 0, 393244, 0, 0, 393245, 0, 0, 393246, 0, 0, 393247, 0, 0, 458752, 0, 0, 458753, 0, 0, 458754, 0, 0, 458755, 0, 0, 458756, 0, 0, 458757, 0, 0, 458758, 0, 0, 458759, 0, 0, 458760, 0, 0, 458761, 0, 0, 458762, 0, 0, 458763, 0, 0, 458764, 0, 0, 458765, 0, 0, 458766, 0, 0, 458767, 0, 0, 458768, 0, 0, 458769, 0, 0, 458770, 0, 0, 458771, 0, 0, 458772, 0, 0, 458773, 0, 0, 458774, 0, 0, 458775, 0, 0, 458776, 0, 0, 458777, 0, 0, 458778, 0, 0, 458779, 0, 0, 458780, 0, 0, 458781, 0, 0, 458782, 0, 0, 458783, 0, 0, 524288, 0, 0, 524289, 0, 0, 524290, 0, 0, 524291, 0, 0, 524292, 0, 0, 524293, 0, 0, 524294, 0, 0, 524295, 0, 0, 524296, 0, 0, 524297, 0, 0, 524298, 0, 0, 524299, 0, 0, 524300, 0, 0, 524301, 0, 0, 524302, 0, 0, 524303, 0, 0, 524304, 0, 0, 524305, 0, 0, 524306, 0, 0, 524307, 0, 0, 524308, 0, 0, 524309, 0, 0, 524310, 0, 0, 524311, 0, 0, 524312, 0, 0, 524313, 0, 0, 524314, 0, 0, 524315, 0, 0, 524316, 0, 0, 524317, 0, 0, 524318, 0, 0, 524319, 0, 0, 589824, 0, 0, 589825, 0, 0, 589826, 0, 0, 589827, 0, 0, 589828, 0, 0, 589829, 0, 0, 589830, 0, 0, 589831, 0, 0, 589832, 0, 0, 589833, 0, 0, 589834, 0, 0, 589835, 0, 0, 589836, 0, 0, 589837, 0, 0, 589838, 0, 0, 589839, 0, 0, 589840, 0, 0, 589841, 0, 0, 589842, 0, 0, 589843, 0, 0, 589844, 0, 0, 589845, 0, 0, 589846, 0, 0, 589847, 0, 0, 589848, 0, 0, 589849, 0, 0, 589850, 0, 0, 589851, 0, 0, 589852, 0, 0, 589853, 0, 0, 589854, 0, 0, 589855, 0, 0, 655360, 0, 0, 655361, 0, 0, 655362, 0, 0, 655363, 0, 0, 655364, 0, 0, 655365, 0, 0, 655366, 0, 0, 655367, 0, 0, 655368, 0, 0, 655369, 0, 0, 655370, 0, 0, 655371, 0, 0, 655372, 0, 0, 655373, 0, 0, 655374, 0, 0, 655375, 0, 0, 655376, 0, 0, 655377, 0, 0, 655378, 0, 0, 655379, 0, 0, 655380, 0, 0, 655381, 0, 0, 655382, 0, 0, 655383, 0, 0, 655384, 0, 0, 655385, 0, 0, 655386, 0, 0, 655387, 0, 0, 655388, 0, 0, 655389, 0, 0, 655390, 0, 0, 655391, 0, 0, 720896, 0, 0, 720897, 0, 0, 720898, 0, 0, 720899, 0, 0, 720900, 0, 0, 720901, 0, 0, 720902, 0, 0, 720903, 0, 0, 720904, 0, 0, 720905, 0, 0, 720906, 0, 0, 720907, 0, 0, 720908, 0, 0, 720909, 0, 0, 720910, 0, 0, 720911, 0, 0, 720912, 0, 0, 720913, 0, 0, 720914, 0, 0, 720915, 0, 0, 720916, 0, 0, 720917, 0, 0, 720918, 0, 0, 720919, 0, 0, 720920, 0, 0, 720921, 0, 0, 720922, 0, 0, 720923, 0, 0, 720924, 0, 0, 720925, 0, 0, 720926, 0, 0, 720927, 0, 0, 786432, 0, 0, 786433, 0, 0, 786434, 0, 0, 786435, 0, 0, 786436, 0, 0, 786437, 0, 0, 786438, 0, 0, 786439, 0, 0, 786440, 0, 0, 786441, 0, 0, 786442, 0, 0, 786443, 0, 0, 786444, 0, 0, 786445, 0, 0, 786446, 0, 0, 786447, 0, 0, 786448, 0, 0, 786449, 0, 0, 786450, 0, 0, 786451, 0, 0, 786452, 0, 0, 786453, 0, 0, 786454, 0, 0, 786455, 0, 0, 786456, 0, 0, 786457, 0, 0, 786458, 0, 0, 786459, 0, 0, 786460, 0, 0, 786461, 0, 0, 786462, 0, 0, 786463, 0, 0, 851968, 0, 0, 851969, 0, 0, 851970, 0, 0, 851971, 0, 0, 851972, 0, 0, 851973, 0, 0, 851974, 0, 0, 851975, 0, 0, 851976, 0, 0, 851977, 0, 0, 851978, 0, 0, 851979, 0, 0, 851980, 0, 0, 851981, 0, 0, 851982, 0, 0, 851983, 0, 0, 851984, 0, 0, 851985, 0, 0, 851986, 0, 0, 851987, 0, 0, 851988, 0, 0, 851989, 0, 0, 851990, 0, 0, 851991, 0, 0, 851992, 0, 0, 851993, 0, 0, 851994, 0, 0, 851995, 0, 0, 851996, 0, 0, 851997, 0, 0, 851998, 0, 0, 851999, 0, 0, 917504, 0, 0, 917505, 0, 0, 917506, 0, 0, 917507, 0, 0, 917508, 0, 0, 917509, 0, 0, 917510, 0, 0, 917511, 0, 0, 917512, 0, 0, 917513, 0, 0, 917514, 0, 0, 917515, 0, 0, 917516, 0, 0, 917517, 0, 0, 917518, 0, 0, 917519, 0, 0, 917520, 0, 0, 917521, 0, 0, 917522, 0, 0, 917523, 0, 0, 917524, 0, 0, 917525, 0, 0, 917526, 0, 0, 917527, 0, 0, 917528, 0, 0, 917529, 0, 0, 917530, 0, 0, 917531, 0, 0, 917532, 0, 0, 917533, 0, 0, 917534, 0, 0, 917535, 0, 0, 983040, 0, 0, 983041, 0, 0, 983042, 0, 0, 983043, 0, 0, 983044, 0, 0, 983045, 0, 0, 983046, 0, 0, 983047, 0, 0, 983048, 0, 0, 983049, 0, 0, 983050, 0, 0, 983051, 0, 0, 983052, 0, 0, 983053, 0, 0, 983054, 0, 0, 983055, 0, 0, 983056, 0, 0, 983057, 0, 0, 983058, 0, 0, 983059, 0, 0, 983060, 0, 0, 983061, 0, 0, 983062, 0, 0, 983063, 0, 0, 983064, 0, 0, 983065, 0, 0, 983066, 0, 0, 983067, 0, 0, 983068, 0, 0, 983069, 0, 0, 983070, 0, 0, 983071, 0, 0, 1048576, 0, 0, 1048577, 0, 0, 1048578, 0, 0, 1048579, 0, 0, 1048580, 0, 0, 1048581, 0, 0, 1048582, 0, 0, 1048583, 0, 0, 1048584, 0, 0, 1048585, 0, 0, 1048586, 0, 0, 1048587, 0, 0, 1048588, 0, 0, 1048589, 0, 0, 1048590, 0, 0, 1048591, 0, 0, 1048592, 0, 0, 1048593, 0, 0, 1048594, 0, 0, 1048595, 0, 0, 1048596, 0, 0, 1048597, 0, 0, 1048598, 0, 0, 1048599, 0, 0, 1048600, 0, 0, 1048601, 0, 0, 1048602, 0, 0, 1048603, 0, 0, 1048604, 0, 0, 1048605, 0, 0, 1048606, 0, 0, 1048607, 0, 0, 1114112, 0, 0, 1114113, 0, 0, 1114114, 0, 0, 1114115, 0, 0, 1114116, 0, 0, 1114117, 0, 0, 1114118, 0, 0, 1114119, 0, 0, 1114120, 0, 0, 1114121, 0, 0, 1114122, 0, 0, 1114123, 0, 0, 1114124, 0, 0, 1114125, 0, 0, 1114126, 0, 0, 1114127, 0, 0, 1114128, 0, 0, 1114129, 0, 0, 1114130, 0, 0, 1114131, 0, 0, 1114132, 0, 0, 1114133, 0, 0, 1114134, 0, 0, 1114135, 0, 0, 1114136, 0, 0, 1114137, 0, 0, 1114138, 0, 0, 1114139, 0, 0, 1114140, 0, 0, 1114141, 0, 0, 1114142, 0, 0, 1114143, 0, 0, 1179648, 0, 0, 1179649, 0, 0, 1179650, 0, 0, 1179651, 0, 0, 1179652, 0, 0, 1179653, 0, 0, 1179654, 0, 0, 1179655, 0, 0, 1179656, 0, 0, 1179657, 0, 0, 1179658, 0, 0, 1179659, 0, 0, 1179660, 0, 0, 1179661, 0, 0, 1179662, 0, 0, 1179663, 0, 0, 1179664, 0, 0, 1179665, 0, 0, 1179666, 0, 0, 1179667, 0, 0, 1179668, 0, 0, 1179669, 0, 0, 1179670, 0, 0, 1179671, 0, 0, 1179672, 0, 0, 1179673, 0, 0, 1179674, 0, 0, 1179675, 0, 0, 1179676, 0, 0, 1179677, 0, 0, 1179678, 0, 0, 1179679, 0, 0, 1245184, 0, 0, 1245185, 0, 0, 1245186, 0, 0, 1245187, 0, 0, 1245188, 0, 0, 1245189, 0, 0, 1245190, 0, 0, 1245191, 0, 0, 1245192, 0, 0, 1245193, 0, 0, 1245194, 0, 0, 1245195, 0, 0, 1245196, 0, 0, 1245197, 0, 0, 1245198, 0, 0, 1245199, 0, 0, 1245200, 0, 0, 1245201, 0, 0, 1245202, 0, 0, 1245203, 0, 0, 1245204, 0, 0, 1245205, 0, 0, 1245206, 0, 0, 1245207, 0, 0, 1245208, 0, 0, 1245209, 0, 0, 1245210, 0, 0, 1245211, 0, 0, 1245212, 0, 0, 1245213, 0, 0, 1245214, 0, 0, 1245215, 0, 0, 1310720, 0, 0, 1310721, 0, 0, 1310722, 0, 0, 1310723, 0, 0, 1310724, 0, 0, 1310725, 0, 0, 1310726, 0, 0, 1310727, 0, 0, 1310728, 0, 0, 1310729, 0, 0, 1310730, 0, 0, 1310731, 0, 0, 1310732, 0, 0, 1310733, 0, 0, 1310734, 0, 0, 1310735, 0, 0, 1310736, 0, 0, 1310737, 0, 0, 1310738, 0, 0, 1310739, 0, 0, 1310740, 0, 0, 1310741, 0, 0, 1310742, 0, 0, 1310743, 0, 0, 1310744, 0, 0, 1310745, 0, 0, 1310746, 0, 0, 1310747, 0, 0, 1310748, 0, 0, 1310749, 0, 0, 1310750, 0, 0, 1310751, 0, 0, 1376256, 0, 0, 1376257, 0, 0, 1376258, 0, 0, 1376259, 0, 0, 1376260, 0, 0, 1376261, 0, 0, 1376262, 0, 0, 1376263, 0, 0, 1376264, 0, 0, 1376265, 0, 0, 1376266, 0, 0, 1376267, 0, 0, 1376268, 0, 0, 1376269, 0, 0, 1376270, 0, 0, 1376271, 0, 0, 1376272, 0, 0, 1376273, 0, 0, 1376274, 0, 0, 1376275, 0, 0, 1376276, 0, 0, 1376277, 0, 0, 1376278, 0, 0, 1376279, 0, 0, 1376280, 0, 0, 1376281, 0, 0, 1376282, 0, 0, 1376283, 0, 0, 1376284, 0, 0, 1376285, 0, 0, 1376286, 0, 0, 1376287, 0, 0, 1441792, 0, 0, 1441793, 0, 0, 1441794, 0, 0, 1441795, 0, 0, 1441796, 0, 0, 1441797, 0, 0, 1441798, 0, 0, 1441799, 0, 0, 1441800, 0, 0, 1441801, 0, 0, 1441802, 0, 0, 1441803, 0, 0, 1441804, 0, 0, 1441805, 0, 0, 1441806, 0, 0, 1441807, 0, 0, 1441808, 0, 0, 1441809, 0, 0, 1441810, 0, 0, 1441811, 0, 0, 1441812, 0, 0, 1441813, 0, 0, 1441814, 0, 0, 1441815, 0, 0, 1441816, 0, 0, 1441817, 0, 0, 1441818, 0, 0, 1441819, 0, 0, 1441820, 0, 0, 1441821, 0, 0, 1441822, 0, 0, 1441823, 0, 0, 1507328, 0, 0, 1507329, 0, 0, 1507330, 0, 0, 1507331, 0, 0, 1507332, 0, 0, 1507333, 0, 0, 1507334, 0, 0, 1507335, 0, 0, 1507336, 0, 0, 1507337, 0, 0, 1507338, 0, 0, 1507339, 0, 0, 1507340, 0, 0, 1507341, 0, 0, 1507342, 0, 0, 1507343, 0, 0, 1507344, 0, 0, 1507345, 0, 0, 1507346, 0, 0, 1507347, 0, 0, 1507348, 0, 0, 1507349, 0, 0, 1507350, 0, 0, 1507351, 0, 0, 1507352, 0, 0, 1507353, 0, 0, 1507354, 0, 0, 1507355, 0, 0, 1507356, 0, 0, 1507357, 0, 0, 1507358, 0, 0, 1507359, 0, 0 )

[node name="TileMap" type="TileMap" parent="."]
tile_set = ExtResource( 1 )
cell_size = Vector2( 8, 8 )
format = 1
tile_data = PoolIntArray( 131074, 1, 0, 131075, 1, 0, 131076, 1, 0, 131077, 1, 0, 196610, 1, 0, 196611, 1, 0, 196612, 1, 0, 196613, 1, 0, 196614, 1, 0, 262146, 1, 0, 262147, 1, 0, 262148, 1, 0, 262149, 1, 0, 262150, 1, 0, 262151, 1, 0, 262152, 3, 0, 327683, 1, 0, 327684, 1, 0, 327685, 1, 0, 327686, 1, 0, 327687, 1, 0, 327688, 1, 0, 327689, 1, 0, 327690, 6, 0, 327691, 7, 0, 327692, 7, 0, 327693, 7, 0, 327694, 7, 0, 327695, 7, 0, 327696, 7, 0, 327697, 7, 0, 327698, 8, 0, 327699, 5, 0, 393220, 1, 0, 393221, 1, 0, 393222, 1, 0, 393223, 1, 0, 393224, 1, 0, 393225, 1, 0, 393235, 5, 0, 458755, 1, 0, 458756, 1, 0, 458757, 1, 0, 458758, 1, 0, 458759, 1, 0, 458760, 1, 0, 458771, 5, 0, 524291, 1, 0, 524292, 1, 0, 524293, 1, 0, 524294, 1, 0, 524295, 1, 0, 524296, 1, 0, 524297, 1, 0, 524300, 2, 0, 524301, 2, 0, 524302, 2, 0, 524303, 2, 0, 524304, 2, 0, 524305, 2, 0, 524307, 5, 0, 589826, 1, 0, 589827, 1, 0, 589828, 1, 0, 589829, 1, 0, 589830, 1, 0, 589831, 1, 0, 589832, 1, 0, 589833, 1, 0, 589834, 2, 0, 589835, 2, 0, 589836, 2, 0, 589837, 2, 0, 589838, 2, 0, 589839, 2, 0, 589840, 2, 0, 589841, 2, 0, 589842, 2, 0, 589843, 2, 0, 589844, 2, 0, 589845, 2, 0, 655362, 1, 0, 655363, 1, 0, 655364, 1, 0, 655365, 1, 0, 655366, 1, 0, 655367, 1, 0, 655368, 1, 0, 655369, 1, 0, 655370, 1, 0, 655371, 2, 0, 655372, 2, 0, 655373, 2, 0, 655374, 2, 0, 655375, 2, 0, 655376, 2, 0, 655377, 2, 0, 655378, 2, 0, 655379, 2, 0, 655380, 1, 0, 655381, 1, 0, 655382, 1, 0, 720898, 1, 0, 720899, 1, 0, 720900, 1, 0, 720901, 1, 0, 720902, 1, 0, 720903, 1, 0, 720904, 1, 0, 720905, 1, 0, 720906, 1, 0, 720907, 2, 0, 720908, 1, 0, 720909, 1, 0, 720910, 1, 0, 720911, 2, 0, 720912, 2, 0, 720913, 2, 0, 720914, 2, 0, 720915, 1, 0, 720916, 1, 0, 720917, 1, 0, 720918, 1, 0, 720919, 1, 0, 786436, 1, 0, 786437, 1, 0, 786438, 1, 0, 786439, 1, 0, 786440, 1, 0, 786441, 1, 0, 786442, 1, 0, 786443, 1, 0, 786444, 1, 0, 786445, 1, 0, 786446, 1, 0, 786447, 1, 0, 786448, 1, 0, 786449, 1, 0, 786450, 1, 0, 786451, 1, 0, 786452, 1, 0, 786453, 1, 0, 786454, 1, 0, 786455, 1, 0, 786456, 1, 0, 786457, 1, 0, 851972, 1, 0, 851973, 1, 0, 851974, 1, 0, 851975, 1, 0, 851976, 1, 0, 851977, 1, 0, 851978, 1, 0, 851979, 1, 0, 851980, 1, 0, 851981, 1, 0, 851982, 1, 0, 851983, 1, 0, 851984, 1, 0, 851985, 1, 0, 851986, 1, 0, 851987, 1, 0, 851988, 1, 0, 851989, 1, 0, 851990, 1, 0, 851991, 1, 0, 851992, 1, 0, 851993, 1, 0, 917510, 1, 0, 917511, 1, 0, 917512, 1, 0, 917513, 1, 0, 917514, 1, 0, 917515, 1, 0, 917516, 1, 0, 917517, 1, 0, 917518, 1, 0, 917519, 1, 0, 917520, 1, 0, 917521, 1, 0, 917522, 1, 0, 917523, 1, 0, 917524, 1, 0, 917525, 1, 0, 917526, 1, 0, 917527, 1, 0, 917528, 1, 0, 917529, 1, 0, 983047, 1, 0, 983048, 1, 0, 983049, 1, 0, 983050, 1, 0, 983051, 1, 0, 983052, 1, 0, 983053, 1, 0, 983054, 1, 0, 983055, 1, 0, 983056, 1, 0, 983057, 1, 0, 983058, 1, 0, 983059, 1, 0, 983060, 1, 0, 983061, 1, 0, 983062, 1, 0, 983063, 1, 0, 1048587, 1, 0, 1048588, 1, 0, 1048589, 1, 0, 1048590, 1, 0, 1048591, 1, 0, 1048592, 1, 0, 1048593, 1, 0, 1048594, 1, 0, 1048595, 1, 0, 1048596, 1, 0, 1114130, 1, 0, 1114131, 1, 0, 1114132, 1, 0 )

[node name="Sprites" type="Node2D" parent="."]

[node name="Node2D" parent="Sprites" instance=ExtResource( 4 )]
position = Vector2( 124, 60 )

[node name="Knight" parent="Sprites" instance=ExtResource( 2 )]
modulate = Color( 0.419608, 0.843137, 0.988235, 1 )
position = Vector2( 108, 60 )

[node name="Camera2D" type="Camera2D" parent="Sprites/Knight"]
current = true
zoom = Vector2( 0.125, 0.125 )
limit_left = 0
limit_top = 0
limit_right = 256
limit_bottom = 192

[node name="Node2D3" parent="Sprites" instance=ExtResource( 4 )]
position = Vector2( 60, 28 )

[node name="Node2D4" parent="Sprites" instance=ExtResource( 6 )]
modulate = Color( 0.729412, 0.192157, 0.709804, 1 )
position = Vector2( 140, 60 )
rotation = 3.14159
scale = Vector2( 1, -1 )

[node name="Archer" parent="Sprites" instance=ExtResource( 7 )]
modulate = Color( 0.419608, 0.843137, 0.988235, 1 )
position = Vector2( 92, 36 )

[node name="Node2D6" parent="Sprites" instance=ExtResource( 6 )]
modulate = Color( 0.729412, 0.192157, 0.709804, 1 )
position = Vector2( 148, 36 )
scale = Vector2( -1, 1 )

[node name="Node2D7" parent="Sprites" instance=ExtResource( 6 )]
modulate = Color( 0.729412, 0.192157, 0.709804, 1 )
position = Vector2( 164, 68 )
scale = Vector2( -1, 1 )
   [gd_scene load_steps=6 format=2]

[ext_resource path="res://Resources/Textures/Sprites.png" type="Texture" id=1]

[sub_resource type="AtlasTexture" id=2]
atlas = ExtResource( 1 )
region = Rect2( 0, 8, 8, 8 )

[sub_resource type="AtlasTexture" id=3]
atlas = ExtResource( 1 )
region = Rect2( 8, 8, 8, 8 )

[sub_resource type="AtlasTexture" id=4]
atlas = ExtResource( 1 )
region = Rect2( 16, 8, 8, 8 )

[sub_resource type="SpriteFrames" id=1]
animations = [ {
"frames": [ SubResource( 2 ), SubResource( 3 ), SubResource( 4 ), SubResource( 3 ) ],
"loop": true,
"name": "default",
"speed": 2.0
} ]

[node name="Node2D" type="Node2D"]

[node name="AnimatedSprite" type="AnimatedSprite" parent="."]
frames = SubResource( 1 )
playing = true
   [gd_scene load_steps=2 format=2]

[ext_resource path="res://Resources/Sprites/Fire.tres" type="SpriteFrames" id=1]

[node name="Node2D" type="Node2D"]

[node name="AnimatedSprite" type="AnimatedSprite" parent="."]
frames = ExtResource( 1 )
frame = 4
playing = true
       [gd_scene load_steps=2 format=2]

[ext_resource path="res://Resources/Sprites/Knight.tres" type="SpriteFrames" id=1]

[node name="Node2D" type="Node2D"]

[node name="AnimatedSprite" type="AnimatedSprite" parent="."]
frames = ExtResource( 1 )
frame = 1
playing = true
     [gd_scene load_steps=2 format=2]

[ext_resource path="res://Resources/Sprites/Zombie.tres" type="SpriteFrames" id=1]

[node name="Node2D" type="Node2D"]

[node name="AnimatedSprite" type="AnimatedSprite" parent="."]
frames = ExtResource( 1 )
playing = true
               GDSC            j      ?????ׄ򶶶?   ??????????????Ŷ   ????????????????????ض??   ???????Ѷ???   ?????¶?   ????¶??   ????????ض??   ?????????Ҷ?   ???????ض???   ????????????????????ض??   ???۶???   ζ??   ϶??             drag                               	                           	   '   
   -      1      5      8      <      D      R      ]      h      3YY;?  Y;?  Y;?  YY0?  P?  QV?  &?  T?  P?  QV?  &?  T?  PQV?  ?  ?  T?  ?  ?  ?  ?  ?  ?  ?  (V?  ?  ?  '?  4?	  ?  V?  ?  ?
  P?  ?  T?  Q?  ?  ?  T?  ?  P?  T?  Q?  ?  T?  ?  P?  T?  QY`          [gd_resource type="Environment" load_steps=2 format=2]

[sub_resource type="ProceduralSky" id=1]

[resource]
background_mode = 2
background_sky = SubResource( 1 )
             GDST@   @            ?  WEBPRIFF?  WEBPVP8L?  /?????m????????_"?0@??^?"?v??s?}? ?W??<f??Yn#I??????wO???M`ҋ???N??m:?
??{-?4b7DԧQ??A ?B?P??*B??v??
Q?-????^R?D???!(????T?B?*?*???%E["??M?\͆B?@?U$R?l)???{?B???@%P????g*Ųs?TP??a??dD
?6?9?UR?s????1ʲ?X?!?Ha?ߛ?$??N????i?a΁}c Rm??1??Q?c???fdB?5??????J˚>>???s1??}????>????Y????TEDױ???s???\?T???4D????]ׯ?(aD??Ѓ!?a'\?G(??$+c$?|'?>????/B??c?v??_oH???9(l?fH??????8??vV?m?^?|?m۶m?????q???k2?='???:_>??????????á????-wӷU?x?˹?fa???????????ӭ?M???SƷ7??????|??v??v???m?d???ŝ,??L??Y??ݛ?X?\֣? ???{?#3????
?6??????t`?
??t?4O??ǎ%????u[B??????O̲H??o߾??$???f???? ?H??\??? ?kߡ}?~$?f???N\??[?=?'??Nr:a???si?????(9Lΰ????=????q-??W??LL%ɩ	??V????R)?=jM????d`?ԙHT?c???'ʦI??DD?R??C׶?&????|t Sw?|WV&?^??bt5WW,v?Ş?qf???+???Jf?t?s?-BG?t?"&?Ɗ????׵?Ջ?KL?2)gD?? ???? NEƋ?R;k?.{L?$?y???{'??`??ٟ??i??{z?5??i???????c???Z^?
h?+U?mC??b??J??uE?c?????h??}{??????i?'?9r??????ߨ򅿿??hR?Mt?Rb???C?DI??iZ?6i"?DN?3???J?zڷ#oL?????Q ?W??D@!'??;??? D*?K?J?%"?0?????pZԉO?A??b%?l?#??$A?W?A?*^i?$?%a??rvU5A?ɺ??'a<??&?DQ??r6ƈZC_B)?N?N(?????(z??y?&H?ض^??1Z4*,RQjԫ׶c????yq??4?????R?????0?6f2Il9j??ZK?4???է?0؍è?ӈ?Uq?3?=[vQ???d$???±eϘA?????R?^??=%:?G?v??)?ǖ/??RcO???z .?ߺ??S&Q????o,X?`?????|??s?<3Z??lns'???vw????Y??>V????G?nuk:??5?U.?v??|????W???Z???4?@U3U???????|?r??;?
         [remap]

importer="texture"
type="StreamTexture"
path="res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://icon.png"
dest_files=[ "res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=true
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
              [remap]

path="res://Scripts/camera.gdc"
       ?PNG

   IHDR   @   @   ?iq?   sRGB ???  ?IDATx???ytTU????ի%???@ȞY1JZ ?iA?i?[P??e??c;?.`Ow+4?>?(}z?EF?Dm?:?h??IHHB?BR!{%?Zߛ???	U?T?
???:??]~???????-?	Ì?{q*?h$e-
?)??'?d?b(??.?B?6???J?ĩ=;???Cv?j??E~Z??+??CQ?AA??????;?.?	?^P	???ARkUjQ?b?,#;?8?6??P~,? ?0?h%*QzE? ?"??T??
?=1p:lX?Pd?Y???(:g?????kZx ??A???띊3G?Di? !?6?????A҆ @?$JkD?$??/?nYE??< Q???<]V?5O!???>2<??f??8?I??8??f:a?|+?/?l9?DEp?-?t]9)C?o??M~?k??tw?r??????w??|r?Ξ?	?S?)^? ??c?eg$?vE17ϟ?(?|???Ѧ*????
????^???uD?̴D????h?????R??O?bv?Y????j^?SN֝
??????PP??????????Y>????&?P??.3+?$??ݷ??????{n?????_5c?99?fbסF&?k?mv???bN?T???F???A?9?
(.?'*"??[??c?{ԛmNު8???3?~V?? az
?沵?f?sD??&+[???ke3o>r????????T?]????* ???f?~nX?Ȉ???w+?G???F?,U?? D?Դ0赍?!?B?q?c?(
ܱ??f?yT?:??1?? +????C|??-?T??D?M??\|?K?j??<yJ, ?????n??1.FZ?d$I0݀8]??Jn_? ???j~?????ցV??????????1@M?)`F?BM????^x?>
?????`??I?˿??wΛ	????W[?????v??E?????u??~??{R?(????3?????????y????C??!??nHe??T??Z?????K?P`ǁF´?nH啝???=>id,?>?GW-糓F??????m<P8?{o[D????w?Q??=N}?!+?????-?<{[?????????w?u?L??????4?????Uc?s??F?륟??c?g?u?s??N??lu???}ן($D??ת8m?Q?V	l?;??(??ڌ???k?
s\??JDIͦOzp??مh????T???IDI???W?Iǧ?X???g??O??a??\:???>????g???%|????i)	?v??]u.?^??:Gk??i)	>??T@k{'	=???????@a?$zZ?;}?󩀒??T?6?Xq&1aWO?,&L?cřT?4P???g[?
p?2??~;? ??Ҭ?29?xri? ?????)??_??@s[??^?ܴhnɝ4&'
??NanZ4??^Js[ǘ??2???x?Oܷ?$??3?$r?????Q??1@?????~??Y?Qܑ?Hjl(}?v?4vSr?iT?1???f???????(????A?ᥕ?$? X,?3'?0s????×ƺk~2~'?[?ё?&F?8{2O?y?n?-`^/FPB??.?N?AO]]?? ?n]β[?SR?kN%;>?k??5??????]8??????=p????Ցh??????`}?
?J?8-??ʺ????? ?fl˫[8??E9q?2&??????p??<??r?8x? [^݂??2?X??z?V+7N????V@j?A????hl??/+/'5?3??;9
?(?Ef'Gyҍ???̣?h4RSS? ??????????j?Z??jI??x??dE-y?a?X?/?????:??? +k?? ?"˖/???+`??],[????UVV4u??P ?˻?AA`??)*ZB\\??9lܸ?]{N??礑]6?Hnnqqq-a??Qxy?7?`=8A?Sm&?Q??????u?0hsPz????yJt?[?>?/ޫ?il?????.??ǳ???9??
_
??<s???wT?S??????;F????-{k?????T?Z^???z?!t?۰؝^?^*???؝c
???;??7]h^
??PA??+@??gA*+?K??ˌ?)S?1??(Ե??ǯ??h????õ?M?`??p?cC?T")?z?j?w??V??@??D??N?^M\?????m?zY??C?Ҙ?I????N?Ϭ??{??9?)????o???C???h?????ʆ.??׏(?ҫ???@?Tf%yZt???wg?4s?]f?q뗣?ǆi?l?⵲3t??I???O??v;Z?g???l??l??kAJѩU^wj?(????????{???)?9?T???KrE?V!?D???aw???x[?I??tZ?0Y ?%E?͹???n?G?P?"5FӨ??M?K?!>R?????$?.x????h=gϝ?K&@-F??=}?=??????5???s ?CFwa???8??u?_????D#???x:R!5&??_?]????*?O??;?)Ȉ?@?g?????ou?Q?v???J?G?6?P???????7??-???	պ^#?C??S??[]3??1???IY??.Ȉ!6\K??:???9?Ev??S]?l;???/? ??5?p?X??f?1?;5??S?ye??Ƅ???,Da?>?? O.?AJL(???pL??C5ij޿hBƾ???ڎ?)s??9$D?p?????I??e?,ə?+;??t??v?p?-??&????	V???x???yuo-G&8->??xt?t??????Rv??Y?4ZnT?4P]?HA?4?a?T?ǅ1`u\?,???hZ????S??????o翿???{?릨ZRq???Y??fat?[????[z9??4?U?V??Anb$Kg??????]??????8?M0(WeU?H??\n_??¹?C??F?F?}????8d?N??.??]???u?,%Z?F-???E?'????q?L?\??????=H?W'?L{?BP0Z???Y?̞???DE??I?N7???c??S???7?Xm?/`?	?+`????X_???KI??^??F\?aD??????~?+M????ㅤ??	SY??/?.?`???:?9Q?c ?38K?j?0Y?D?8????W;ܲ?pTt??6P,? Nǵ??Æ?:(???&?N?/ X??i%???_P	?n?F?.^?G?E???鬫>????"@v?2???A~?aԹ_[P, n????N??????_rƢ??    IEND?B`?       ECFG      application/config/name         TacticalRoguelike      application/run/main_scene$         res://Scenes/MainScene.tscn    application/config/icon         res://icon.png     display/window/size/height            display/window/size/resizable             importer_defaults/texture?              compress/bptc_ldr                compress/hdr_mode                compress/lossy_quality    ffffff??      compress/mode                compress/normal_map           	   detect_3d                flags/anisotropic                flags/filter             flags/mipmaps                flags/repeat          
   flags/srgb              process/HDR_as_SRGB              process/fix_alpha_border            process/invert_color             process/normal_map_invert_y              process/premult_alpha             
   size_limit               stream            	   svg/scale        ??
   input/drag?              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device            alt           shift             control           meta          command           button_mask           position              global_position               factor       ??   button_index         pressed           doubleclick           script      )   physics/common/enable_pause_aware_picking         %   rendering/vram_compression/import_etc         &   rendering/vram_compression/import_etc2          )   rendering/environment/default_clear_color                    ??)   rendering/environment/default_environment          res://default_env.tres  