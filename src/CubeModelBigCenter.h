#pragma once
#include "Model.h"
#include "buffers.h"


class CubeModelBigCenter : public Model
{
	unsigned m_number_of_indices = 0;
	Material material;
	

public:

	

	CubeModelBigCenter(ID3D11Device* dxdevice, ID3D11DeviceContext* dxdevice_context);

	virtual void Render(ID3D11Buffer* materialBuffer) const;


	~CubeModelBigCenter() { };



	
};