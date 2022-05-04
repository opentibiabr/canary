/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
 * <https://github.com/opentibiabr/canary>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/

#ifndef SRC_UTILS_DATABUFFER_HPP_
#define SRC_UTILS_DATABUFFER_HPP_

template<class T>
class DataBuffer
{
public:
	DataBuffer(unsigned int res = 64) : m_capacity(res), m_buffer(new T[m_capacity]) {}
	~DataBuffer()
	{
		delete[] m_buffer;
	}

	void reset() { m_size = 0; }

	void clear()
	{
		m_size = 0;
		m_capacity = 0;
		delete[] m_buffer;
		m_buffer = nullptr;
	}

	bool empty() const { return m_size == 0; }
	unsigned int size() const { return m_size; }
	T* data() const { return m_buffer; }

	const T& at(unsigned int i) const { return m_buffer[i]; }
	const T& last() const { return m_buffer[m_size - 1]; }
	const T& first() const { return m_buffer[0]; }
	const T& operator[](unsigned int i) const { return m_buffer[i]; }
	T& operator[](unsigned int i) { return m_buffer[i]; }

	void reserve(unsigned int n)
	{
		if (n > m_capacity) {
			T* buffer = new T[n];
			for (unsigned int i = 0; i < m_size; ++i)
				buffer[i] = m_buffer[i];

			delete[] m_buffer;
			m_buffer = buffer;
			m_capacity = n;
		}
	}

	void resize(unsigned int n, T def = T())
	{
		if (n == m_size)
			return;
		reserve(n);
		for (unsigned int i = m_size; i < n; ++i)
			m_buffer[i] = def;
		m_size = n;
	}

	void grow(unsigned int n)
	{
		if (n <= m_size)
			return;
		if (n > m_capacity) {
			unsigned int newcapacity = m_capacity;
			do { newcapacity *= 2; } while (newcapacity < n);
			reserve(newcapacity);
		}
		m_size = n;
	}

	void add(const T& v)
	{
		grow(m_size + 1);
		m_buffer[m_size - 1] = v;
	}

	DataBuffer& operator<<(const T& t) { add(t); return *this; }

private:
	unsigned int m_size{ 0 };
	unsigned int m_capacity;
	T* m_buffer;
};

#endif  // SRC_UTILS_DATABUFFER_HPP_
