vec4 effect(vec4 color, Image texture, vec2 imageCords, vec2 screenCords){
    //vec4 texColor = Texel(texture, imageCords);
    return vec4(mix(0.5, 1.0, imageCords.x), 0.2, 0.2, color.a);
}