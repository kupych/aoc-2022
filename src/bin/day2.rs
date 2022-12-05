use std::fs;

fn main() -> Result<(), ()> {
    const rounds = fs::read_to_string("./files/2")
        .expect("Could not read input file")
        .split("\n+")
        .map(|c| c.split(" "));

    println!("{:?}", rounds);


    let part1 = "a";
    let part2 = "b";

    println!("Solution to Part 1 is: {part1}");
    println!("Solution to Part 2 is: {part2}");

    Ok(())
}
