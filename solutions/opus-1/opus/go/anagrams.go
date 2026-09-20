package main

import (
	"bufio"
	"os"
	"sort"
	"strings"
)

func main() {
	sc := bufio.NewScanner(os.Stdin)
	sc.Buffer(make([]byte, 1024*1024), 1024*1024*64)
	groups := map[string][]string{}
	for sc.Scan() {
		w := strings.TrimSpace(sc.Text())
		if w == "" {
			continue
		}
		b := []byte(w)
		sort.Slice(b, func(i, j int) bool { return b[i] < b[j] })
		k := string(b)
		groups[k] = append(groups[k], w)
	}
	list := make([][]string, 0, len(groups))
	for _, g := range groups {
		sort.Strings(g)
		list = append(list, g)
	}
	sort.Slice(list, func(i, j int) bool { return list[i][0] < list[j][0] })
	out := bufio.NewWriter(os.Stdout)
	defer out.Flush()
	for _, g := range list {
		out.WriteString(strings.Join(g, " "))
		out.WriteByte('\n')
	}
}
