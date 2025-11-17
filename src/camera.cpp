#include "Camera.h"

using namespace linalg;

void Camera::MoveTo(const vec3f& position) noexcept
{
	m_position = position;
}

void Camera::Move(const vec4f& forward) noexcept
{
	//std::cout << forward << std::endl;

	m_position.x += forward.x;
	m_position.y += forward.y;
	m_position.z += forward.z;
}


void Camera::RotateY(long mousedx) noexcept
{
	m_rotation.y += mousedx*0.001;

	
}
void Camera::RotateX(long mousedy) noexcept
{
	m_rotation.x += mousedy*0.001;
	if (m_rotation.x > 1)
	{
		m_rotation.x = 1;
	};
	if (m_rotation.x < -1)
	{
		m_rotation.x = -1;
	};
}

mat4f Camera::WorldToViewMatrix() const noexcept
{
	// Assuming a camera's position and rotation is defined by matrices T(p) and R,
	// the View-to-World transform is T(p)*R (for a first-person style camera).
	//
	// World-to-View then is the inverse of T(p)*R;
	//		inverse(T(p)*R) = inverse(R)*inverse(T(p)) = transpose(R)*T(-p)
	// Since now there is no rotation, this matrix is simply T(-p)
	mat4f m = mat4f::rotation(m_rotation.z, -m_rotation.y, -m_rotation.x);
	m.transpose();
	return m * mat4f::translation(-m_position);

}

mat4f Camera::ViewToWorldMatrix() const noexcept
{
	// Assuming a camera's position and rotation is defined by matrices T(p) and R,
	// the View-to-World transform is T(p)*R (for a first-person style camera).
	//
	// World-to-View then is the inverse of T(p)*R;
	//		inverse(T(p)*R) = inverse(R)*inverse(T(p)) = transpose(R)*T(-p)
	// Since now there is no rotation, this matrix is simply T(-p)
	
	return mat4f::translation(m_position) * mat4f::rotation(m_rotation.z, -m_rotation.y, -m_rotation.x);

}

mat4f Camera::ProjectionMatrix() const noexcept
{
	return mat4f::projection(m_vertical_fov, m_aspect_ratio, m_near_plane, m_far_plane);
}