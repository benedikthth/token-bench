package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	n, _ := strconv.Atoi(scanner.Text())

	primes := sieveOfEratosthenes(n)

	if len(primes) == 0 {
		fmt.Println()
	} else {
		for i, p := range primes {
			if i > 0 {
				fmt.Print(" ")
			}
			fmt.Print(p)
		}
		fmt.Println()
	}
}

func sieveOfEratosthenes(n int) []int {
	if n < 2 {
		return []int{}
	}

	// Create a boolean array "prime[0..n]" and initialize all entries as true
	prime := make([]bool, n+1)
	for i := 2; i <= n; i++ {
		prime[i] = true
	}

	// Start with the smallest prime number, 2
	p := 2
	for p*p <= n {
		// If prime[p] is not changed, then it is a prime
		if prime[p] {
			// Mark all multiples of p as not prime
			for i := p * p; i <= n; i += p {
				prime[i] = false
			}
		}
		p++
	}

	// Collect all prime numbers
	var result []int
	for i := 2; i <= n; i++ {
		if prime[i] {
			result = append(result, i)
		}
	}

	return result
}
