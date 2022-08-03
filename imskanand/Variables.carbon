package imskanand api;

fn OutputString() {
    // var -> Dynamic
    var my_name: String = "imskanand";
    my_name = "Shubham Kumar Anand";
    Print(my_name);

    // let -> Constant cannot be reassigned
    let college_name: String = "ACET";
    // college_name = "IIT";
    Print(college_name);
}

fn Main() -> i32 {
   OutputString();
    return 0;
}
