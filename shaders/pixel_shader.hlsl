
Texture2D texDiffuse : register(t0);
Texture2D texNormal : register(t1);
TextureCube texCube : register(t2);
Texture2D texSpecular : register(t3);
SamplerState texSampler : registers0;
SamplerState texSamplerText : registers1;

cbuffer LightCameraBuffer : register(b0)
{
    float4 LightPos;
    float4 CameraPos;
};

cbuffer MaterialBuffer : register(b1)
{
    float4 AmbientColor;
    float4 DiffuseColor;
    float4 SpecularColor;
};

struct PSIn
{
	float4 Pos  : SV_Position;
	float4 PosWorld  : COLOR;
    float3 Normal : NORMAL;
    float3 Tangent : TANGENT;
    float3 Binormal : BINORMAL;
	float2 TexCoord : TEX;
};


float4 PS_main(PSIn input) : SV_Target
{
    float3 color;
    float3 color1 = { 1, 0, 0 };
    
      
    float4 textureDiffuse = texDiffuse.Sample(texSampler, input.TexCoord);
    
    
    float3 T = normalize(input.Tangent);
    float3 B = normalize(input.Binormal);
    float3 normalN = normalize(input.Normal); //from vertex
            
    float3x3 TBN = transpose(float3x3(T, B, normalN));
    
    float3 textureNormal = texNormal.Sample(texSampler, input.TexCoord).xyz;
    textureNormal = textureNormal * 2 - 1; // color to vector
    textureNormal = mul(TBN, textureNormal);
    float3 textureSpecular = texSpecular.Sample(texSampler, input.TexCoord).xyz;
    textureSpecular = textureSpecular * 2 - 1;
    textureSpecular = mul(TBN, textureSpecular);
    
   
    //light and camera vector
    float3 L = normalize(LightPos.xyz - input.PosWorld.xyz);
    float3 V = normalize(CameraPos.xyz - input.PosWorld.xyz);
    
    //camera reflect vector
    //float3 cubeReflect = normalize(reflect(V)...;
    float3 cubeReflect = V;
    float4 reflectionCube = texCube.Sample(texSamplerText, cubeReflect);
    
    //diffuse
    float3 dotLN = dot(L, normalN);
    
    //specular
    //float3 R = normalize(2.0 * dot(L, normalN) * normalN - L);
    float3 R = normalize(reflect(-L, normalN));
    float RV = max(dot(R, V), 0); // removing negative angle?
    float raisedRV = pow(RV, SpecularColor.w);
    
    //factors
    float ambientFactor = 0.050f;
    float diffuseFactor = 1.000f;
    float specularFactor = 1.000f;
    
    
    color = AmbientColor.xyz * ambientFactor + textureDiffuse.xyz * dotLN * diffuseFactor + SpecularColor.xyz * raisedRV * specularFactor;
    
    
    //return float4 (color, 1);
    return float4(textureNormal*0.5 +0.5, 1);
    

}