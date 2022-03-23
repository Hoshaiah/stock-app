const link = document.getElementById("quote_link")
let input = document.getElementById("transaction_stock")
const originalHREF = link.href
link.href += input.value

function output(value) {
    value = value.replace("+","%2B")
    link.href = originalHREF + value
}

input.addEventListener("change", ()=> {
    output(input.value)
})