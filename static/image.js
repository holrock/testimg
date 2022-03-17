function keyup(ev) {
	document.removeEventListener('keyup', keyup)
	const code = ev.code
	const anime = "animate-ping"
	let t = null
	if (code === "KeyJ") {
		t = document.querySelector("#valid")
	}
	if (code === "KeyK") {
		t = document.querySelector("#invalid")
	}
	if (!t) return
	t.classList.add(anime)
	setTimeout(() => {
		t.click()
	}, 500)
}

function init() {
	document.addEventListener('keyup', keyup)
}
document.addEventListener("DOMContentLoaded", () => init())