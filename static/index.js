function download() {
	fetch("/json")
	.then(res => res.json())
	.then(json =>{ 
		let s = JSON.stringify(json)
		let a = document.createElement("a")
		let b = new Blob([s], {type: "text/plain"})
		a.href = URL.createObjectURL(b)
		a.download = 'image.json'
		a.click()
	})
}
document.addEventListener("DOMContentLoaded", (ev) => {
	let dlb = document.querySelector("#download")
	dlb.addEventListener('click', download)
})