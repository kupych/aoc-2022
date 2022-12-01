use std::fs;

fn main() -> Result<(), ()> {
    let mut calories = fs::read_to_string("./files/1")
        .expect("Could not read input file")
        .split("\n\n")
        .map(|c| c.lines().map(|l| l.parse::<i32>().unwrap()).sum::<i32>())
        .collect::<Vec<_>>();

    calories.sort_by(|a, b| b.cmp(a));

    let part1 = calories[0];
    let part2 = calories[0..3].iter().sum::<i32>();

    println!("Solution to Part 1 is: {part1}");
    println!("Solution to Part 2 is: {part2}");

    Ok(())
}
