const quote_button= document.getElementById("quote_link")
const quote_all_button = document.getElementById("quote_all_link")
let symbol_picker = document.getElementById("transaction_stock")

const originalHREF = quote_button.href
quote_button.href += symbol_picker.value
quote_all_button.href += symbol_picker.value

function output(symbol_picked) {
    symbol = symbol_picked.replace("+","%2B")

    quote_button.href = originalHREF + symbol_picked 
    quote_all_button.href = originalHREF + symbol_picked
}

symbol_picker.addEventListener("change", ()=> {
    output(symbol_picker.value)
})