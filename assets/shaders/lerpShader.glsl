uniform float b;
uniform float t;

vec4 effect(vec4 color, Image texture, vec2 imageCords, vec2 screenCords){
    //this is mostly used for me to learn tha actually useful shader - it just dimms the whole world

    vec4 texColor = Texel(texture, imageCords);
    //a = a - (b - a) * t
    return vec4(texColor.r + (b - texColor.r) * t, texColor.g + (b - texColor.g) * t, texColor.b + (b - texColor.b) * t, texColor.a);
}