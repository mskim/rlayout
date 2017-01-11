require 'yaml'

h = {
  info: {
    doc_type: "NAMECARD",
  },
  page_1: {
    personal: {
      grid: [0,0,1,1],
      name: {text: "김민수", font: "Times", size: 10.2},
      division: "",
      title: "소장",
      email: "mskimsdi@gmail.com",
    },

  },
  page_2: {
    name: "Min Soo Kim",
    division: "",
    title: "CTO",
    email: "mskimsdi@gmail.com",

  }
}

puts h.to_yaml
