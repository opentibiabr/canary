/*
	BigInt
	------
	Arbitrary-sized integer class for C++.

	Version: 0.5.0-dev
	Released on: 05 October 2020 23:15 IST
	Author: Syed Faheel Ahmad (faheel@live.in)
	Project on GitHub: https://github.com/faheel/BigInt
	License: MIT
*/

/*
	===========================================================================
	BigInt
	===========================================================================
	Definition for the BigInt class.
*/

#ifndef BIG_INT_HPP
#define BIG_INT_HPP

#include <iostream>
#include <string>

class BigInt {
		std::string value;
		char sign;

	public:
		// Constructors:
		BigInt();
		BigInt(const BigInt &);
		BigInt(const long long &);
		BigInt(const std::string &);

		// Assignment operators:
		BigInt &operator=(const BigInt &);
		BigInt &operator=(const long long &);
		BigInt &operator=(const std::string &);

		// Unary arithmetic operators:
		BigInt operator+() const; // unary +
		BigInt operator-() const; // unary -

		// Binary arithmetic operators:
		BigInt operator+(const BigInt &) const;
		BigInt operator-(const BigInt &) const;
		BigInt operator*(const BigInt &) const;
		BigInt operator/(const BigInt &) const;
		BigInt operator%(const BigInt &) const;
		BigInt operator+(const long long &) const;
		BigInt operator-(const long long &) const;
		BigInt operator*(const long long &) const;
		BigInt operator/(const long long &) const;
		BigInt operator%(const long long &) const;
		BigInt operator+(const std::string &) const;
		BigInt operator-(const std::string &) const;
		BigInt operator*(const std::string &) const;
		BigInt operator/(const std::string &) const;
		BigInt operator%(const std::string &) const;

		// Arithmetic-assignment operators:
		BigInt &operator+=(const BigInt &);
		BigInt &operator-=(const BigInt &);
		BigInt &operator*=(const BigInt &);
		BigInt &operator/=(const BigInt &);
		BigInt &operator%=(const BigInt &);
		BigInt &operator+=(const long long &);
		BigInt &operator-=(const long long &);
		BigInt &operator*=(const long long &);
		BigInt &operator/=(const long long &);
		BigInt &operator%=(const long long &);
		BigInt &operator+=(const std::string &);
		BigInt &operator-=(const std::string &);
		BigInt &operator*=(const std::string &);
		BigInt &operator/=(const std::string &);
		BigInt &operator%=(const std::string &);

		// Increment and decrement operators:
		BigInt &operator++(); // pre-increment
		BigInt &operator--(); // pre-decrement
		BigInt operator++(int); // post-increment
		BigInt operator--(int); // post-decrement

		// Relational operators:
		bool operator<(const BigInt &) const;
		bool operator>(const BigInt &) const;
		bool operator<=(const BigInt &) const;
		bool operator>=(const BigInt &) const;
		bool operator==(const BigInt &) const;
		bool operator!=(const BigInt &) const;
		bool operator<(const long long &) const;
		bool operator>(const long long &) const;
		bool operator<=(const long long &) const;
		bool operator>=(const long long &) const;
		bool operator==(const long long &) const;
		bool operator!=(const long long &) const;
		bool operator<(const std::string &) const;
		bool operator>(const std::string &) const;
		bool operator<=(const std::string &) const;
		bool operator>=(const std::string &) const;
		bool operator==(const std::string &) const;
		bool operator!=(const std::string &) const;

		// I/O stream operators:
		friend std::istream &operator>>(std::istream &, BigInt &);
		friend std::ostream &operator<<(std::ostream &, const BigInt &);

		// Conversion functions:
		std::string to_string() const;
		int to_int() const;
		long to_long() const;
		long long to_long_long() const;

		// Random number generating functions:
		friend BigInt big_random(size_t);
};

#endif // BIG_INT_HPP
